//
//  FavouritesViewModel.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 16/11/2023.
//

import UIKit

class FavouritesViewModel {

    lazy var characterThumbnails: [CharacterThumbnail] = []

    init(characterThumbnails: [CharacterThumbnail] = []) {

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

    func changeFavourite(id: Int ,favourite: Bool) {

        if let characterThumbnail = characterThumbnails.first(where: {$0.id == id}) {

            characterThumbnail.favourite = favourite
            if let indexOfCharacterThumbnail = characterThumbnails.firstIndex(where: {$0.id == id}) {

                characterThumbnails.remove(at: Int(indexOfCharacterThumbnail))
            }
        }
    }

    func setCharacterThumbnails(characterThumbnails: [CharacterThumbnail]) {

        self.characterThumbnails = characterThumbnails
    }
}

