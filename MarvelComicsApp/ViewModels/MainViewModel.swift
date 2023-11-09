//
//  MainViewModel.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 09/11/2023.
//

import Foundation

class MainViewModel {

    private let webservice = MainWebservice()

    lazy var characterThumbnails: [CharacterThumbnail] = []

    func numberOfRows() -> Int {

        return self.characterThumbnails.count
    }

    func characterForRowAt(indexPath: IndexPath) -> CharacterThumbnail {

        return characterThumbnails[indexPath.row]
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

                let imageData = try await webservice.fetchCharactersImageData(name: name,url: imageUrl)

                let characterThumbnail = CharacterThumbnail(id: id, name: name, imageData: imageData)

                characterThumbnails.append(characterThumbnail)
            }
        } catch { print(error) }
    }
}
