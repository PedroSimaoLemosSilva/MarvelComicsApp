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

    func numberOfRows() -> Int {

        return self.characterThumbnails.count
    }

    func characterForRowAt(indexPath: IndexPath) -> (Int, String, UIImage) {

        let id = characterThumbnails[indexPath.row].id
        let name = characterThumbnails[indexPath.row].name
        let image = characterThumbnails[indexPath.row].image

        return (id, name, image)
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

                let characterThumbnail = CharacterThumbnail(id: id, name: name, image: image)

                characterThumbnails.append(characterThumbnail)
            }
            
        } catch { print(error) }
    }
}
