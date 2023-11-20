//
//  FavouritesViewModel.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 16/11/2023.
//

import UIKit

class FavouritesViewModel {

    private let webservice: FavouritesWebserviceProtocol

    var characterThumbnails: [CharacterThumbnail] = []

    var characterThumbnailsDeleted: [CharacterThumbnail] = []

    var favouritesId: [Int] = []

    var favouritesIdNotLoaded: [Int] = []

    init(webservice: FavouritesWebserviceProtocol = FavouritesWebservice(), characterThumbnails: [CharacterThumbnail] = [],
         characterThumbnailsDeleted: [CharacterThumbnail] = [], favouritesId: [Int] = [], favouritesIdNotLoaded: [Int] = []) {

        self.webservice = webservice
        self.characterThumbnails = characterThumbnails
        self.characterThumbnailsDeleted = characterThumbnailsDeleted
        self.favouritesId = favouritesId
        self.favouritesIdNotLoaded = favouritesIdNotLoaded
    }

    func numberOfRows() -> Int? {

        return self.characterThumbnails.count
    }

    func characterForRowAt(indexPath: IndexPath) -> (Int, String, UIImage, Bool)? {

        let id = characterThumbnails[indexPath.row].id
        let name = characterThumbnails[indexPath.row].name
        let image = characterThumbnails[indexPath.row].image
        let favourite = characterThumbnails[indexPath.row].favourite

        return (id, name, image, favourite)
    }

    func changeFavourite(id: Int ,favourite: Bool) {
        
        if let characterThumbnail = characterThumbnails.first(where: {$0.id == id}) {

            characterThumbnail.favourite = favourite
            if let indexOfCharacterThumbnail = characterThumbnails.firstIndex(where: {$0.id == id}),
               let indexOfId = favouritesId.firstIndex(where: {$0 == id}),
               characterThumbnail.favourite == false {

                characterThumbnails.remove(at: Int(indexOfCharacterThumbnail))
                characterThumbnailsDeleted.append(characterThumbnail)
                favouritesId.remove(at: Int(indexOfId))
            }
        } else {

            favouritesId.append(id)
            if let characterThumbnail = characterThumbnailsDeleted.first(where: {$0.id == id}) {

                characterThumbnails.append(characterThumbnail)
                characterThumbnails.sort(by: { $0.name < $1.name })
                if let indexOfCharacterThumbnailDeleted = characterThumbnailsDeleted.firstIndex(where: {$0.id == id}) {

                    characterThumbnailsDeleted.remove(at: Int(indexOfCharacterThumbnailDeleted))
                }
            }
        }
    }

    func saveChanges() {

        UserDefaults.standard.set(favouritesId, forKey: "favouriteId")
    }

    func setCharacterThumbnails(characterThumbnails: [CharacterThumbnail]) {

        self.characterThumbnails = characterThumbnails
    }

    func checkFavouriteInList() {

        favouritesId.forEach { id in

            if let characterThumbnail = characterThumbnails.first(where: {$0.id == id}) {}
            else {

                favouritesIdNotLoaded.append(id)
            }
        }
    }

    func dataLoad() async {

        for id in favouritesIdNotLoaded {

            do {

                guard let characterDataWrapper = try await webservice.fetchCharacter(id: id),
                      let charactersData = characterDataWrapper.data?.results else { return }

                for character in charactersData {

                    guard let id = character.id,
                          let name = character.name,
                          let path = character.thumbnail?.path,
                          let ext = character.thumbnail?.extension0 else { return }

                    let imageUrl = path + "." + ext

                    guard let imageData = try await webservice.fetchCharactersImageData(name: name,url: imageUrl) else { return }

                    guard let image = UIImage(data: imageData) else { return }

                    let characterThumbnail = CharacterThumbnail(id: id, name: name, image: image, favourite: true)

                    characterThumbnails.append(characterThumbnail)
                }
            } catch { print(error) }
        }
        
        characterThumbnails.sort(by: { $0.name < $1.name })
    }
}

