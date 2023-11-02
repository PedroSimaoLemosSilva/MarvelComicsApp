//
//  FetchedInfo.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 02/11/2023.
//

import Foundation

struct CharacterThumbnail {

    let id: Int //The unique ID of the character resource
    let name: String //Character's name
    let imageUrl: String //The full URL of the image

    init(id: Int,  name: String, imageUrl: String) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
    }
}
