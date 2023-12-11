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

    var favouriteIds: FavouritesSet = FavouritesSet.sharedInstance

    var favouritesIdNotLoaded: Set<Int> = []

    var cache = NSCache<NSString, UIImage>()

    init(webservice: FavouritesWebserviceProtocol = FavouritesWebservice(), characterThumbnails: [CharacterThumbnail] = [],
         characterThumbnailsDeleted: [CharacterThumbnail] = [], favouriteIds: FavouritesSet = FavouritesSet.sharedInstance, favouritesIdNotLoaded: Set<Int> = []) {
        
        self.webservice = webservice
        self.characterThumbnails = characterThumbnails
        self.characterThumbnailsDeleted = characterThumbnailsDeleted
        self.favouriteIds = favouriteIds
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

    func characterForRowAtImage(indexPath: IndexPath) -> (Int, String, UIImage, Bool) {

        let id = characterThumbnails[indexPath.row].id
        let name = characterThumbnails[indexPath.row].name
        let image = characterThumbnails[indexPath.row].image
        let favourite = characterThumbnails[indexPath.row].favourite

        return (id, name, image, favourite)
        /*
        if characterThumbnails[indexPath.row].favourite {

            guard let newHeart = UIImage(named: "icons8-heart-50 (1).png") else { return nil }

            if let heart = cache.object(forKey: NSString(string: name)) {

                if heart.pngData() == newHeart.pngData() {

                    return (id, name, image, heart)
                } else {

                    cache.setObject(newHeart, forKey: NSString(string: name))
                    return (id, name, image, newHeart)
                }
            } else {

                cache.setObject(newHeart, forKey: NSString(string: name))

                return (id, name, image, newHeart)
            }
        } else {

            guard let newHeart = UIImage(named: "icons8-heart-50.png") else { return nil }

            if let heart = cache.object(forKey: NSString(string: name)) {

                if heart.pngData() == newHeart.pngData() {

                    return (id, name, image, heart)
                } else {

                    cache.setObject(newHeart, forKey: NSString(string: name))
                    return (id, name, image, newHeart)
                }
            } else {

                cache.setObject(newHeart, forKey: NSString(string: name))

                return (id, name, image, newHeart)
            }
        }*/
    }

    func changeFavourite(id: Int) {

        if let characterThumbnail = characterThumbnails.first(where: {$0.id == id}) {

            characterThumbnail.favourite.toggle()
            if let indexOfCharacterThumbnail = characterThumbnails.firstIndex(where: {$0.id == id}),
               characterThumbnail.favourite == false {

                characterThumbnails.remove(at: Int(indexOfCharacterThumbnail))
                characterThumbnailsDeleted.append(characterThumbnail)
                favouriteIds.removeFavourite(id: id)
            }
        } else {

            favouriteIds.addFavourite(id: id)
            if let characterThumbnail = characterThumbnailsDeleted.first(where: {$0.id == id}) {

                characterThumbnail.favourite.toggle()

                characterThumbnails.append(characterThumbnail)
                characterThumbnails.sort(by: { $0.name < $1.name })
                if let indexOfCharacterThumbnailDeleted = characterThumbnailsDeleted.firstIndex(where: {$0.id == id}) {

                    characterThumbnailsDeleted.remove(at: Int(indexOfCharacterThumbnailDeleted))
                }
            }
        }
    }

    func modifyFavouriteId(id: Int) {

        if let characterThumbnail = characterThumbnails.first(where: {$0.id == id}) {

            if let indexOfCharacterThumbnail = characterThumbnails.firstIndex(where: {$0.id == id}),
               characterThumbnail.favourite == false {

                characterThumbnails.remove(at: Int(indexOfCharacterThumbnail))
                characterThumbnailsDeleted.append(characterThumbnail)
                favouriteIds.removeFavourite(id: id)
            }
        } else {

            favouriteIds.addFavourite(id: id)
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

        let array = Array(favouriteIds.getFavourites())
        UserDefaults.standard.set(array, forKey: "favouriteId")
    }

    func setCharacterThumbnails(characterThumbnails: [CharacterThumbnail]) {

        self.characterThumbnails = characterThumbnails
    }

    func checkFavouriteInList() {

        favouriteIds.getFavourites().forEach { id in
            
            if let characterThumbnail = characterThumbnails.first(where: {$0.id == id}) {}
            else {

                favouritesIdNotLoaded.insert(id)
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

