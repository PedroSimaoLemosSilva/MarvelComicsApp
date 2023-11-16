//
//  MainViewModel.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 09/11/2023.
//

import Foundation
import UIKit
import Combine

class MainViewModel {

    private let webservice: MainWebserviceProtocol

    lazy var characterThumbnails: [CharacterThumbnail] = []

    init(webservice: MainWebserviceProtocol = MainWebservice(), characterThumbnails: [CharacterThumbnail] = []) {

        self.webservice = webservice
        self.characterThumbnails = characterThumbnails
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

    func toggleChecked(indexPath: IndexPath) {

        characterThumbnails[indexPath.row].favourite = !characterThumbnails[indexPath.row].favourite
    }

    func changeFavourite(id: Int ,favourite: Bool) {

        if let characterThumbnail = characterThumbnails.first(where: {$0.id == id}) {

            characterThumbnail.favourite = favourite
        }
    }

    func favouriteCharacterThumbnails() -> [CharacterThumbnail] {

        let favouriteCharacterThumbnailIds = characterThumbnails.filter { characterThumbnail in

            if characterThumbnail.favourite {

                return true
            } else {

                return false
            }
        }

        return favouriteCharacterThumbnailIds
    }

    func dataLoad() async {
        
        do {

            guard let characterDataWrapper = try await webservice.fetchCharactersInfo(),
                  let charactersData = characterDataWrapper.data?.results else { return }

            for character in charactersData {

                guard let id = character.id,
                      let name = character.name,
                      let path = character.thumbnail?.path,
                      let ext = character.thumbnail?.extension0 else { return }

                let imageUrl = path + "." + ext

                guard let imageData = try await webservice.fetchCharactersImageData(name: name,url: imageUrl) else { return }

                guard let image = UIImage(data: imageData) else { return }

                let characterThumbnail = CharacterThumbnail(id: id, name: name, image: image, favourite: false)

                characterThumbnails.append(characterThumbnail)
            }
        } catch { print(error) }
    }
}
