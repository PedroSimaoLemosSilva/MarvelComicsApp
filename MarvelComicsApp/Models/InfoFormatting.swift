//
//  FetchedInfo.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 02/11/2023.
//

import Foundation
import UIKit

class CharacterThumbnail {

    let id: Int //The unique ID of the character resource
    let name: String //Character's name
    let image: UIImage //The full URL of the image
    var favourite: Bool

    init() {

        self.id = 0
        self.name = ""
        self.image = UIImage()
        self.favourite = false
    }

    init(id: Int,  name: String, image: UIImage, favourite: Bool) {

        self.id = id
        self.name = name
        self.image = image
        self.favourite = favourite
    }

    init(character: CharacterThumbnail) {

        self.id = character.id
        self.name = character.name
        self.image = character.image
        self.favourite = character.favourite
    }
}
