//
//  CharacterInfo.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 26/10/2023.
//

import Foundation
/*
struct Characters: Decodable {

    let charcters: [CharacterInfo]
}

struct CharacterInfo: Decodable {

    let id: String
    let name: String
    let thumbnailPath: String
}
*/

struct CharactersDataWrapper: Decodable, Encodable {

    let data: CharactersDataContainer? //The results returned by the call.

    
}

struct CharactersDataContainer: Decodable, Encodable {

    let results: [Character]? //The list of characters returned by the call.
}

struct Character: Decodable, Encodable {

    let id: Int? //The unique ID of the character resource.,
    let name: String?  //The name of the character.,
    let thumbnail: Image?  //The representative image for this character.
}

struct Image: Decodable, Encodable {

    let path: String? //The directory path of to the image.,
    let extension0: String? //The file extension for the image.

    enum CodingKeys: String, CodingKey {

        case extension0 = "extension"
        case path
    }
}
