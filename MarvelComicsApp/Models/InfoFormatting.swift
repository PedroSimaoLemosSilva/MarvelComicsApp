//
//  FetchedInfo.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 02/11/2023.
//

import Foundation
import UIKit

struct CharacterThumbnail {

    let id: Int //The unique ID of the character resource
    let name: String //Character's name
    let image: UIImage //The full URL of the image

    init() {

        self.id = 0
        self.name = ""
        self.image = UIImage()
    }

    init(id: Int,  name: String, image: UIImage) {

        self.id = id
        self.name = name
        self.image = image
    }

    init(character: CharacterThumbnail) {

        self.id = character.id
        self.name = character.name
        self.image = character.image
    }
}
