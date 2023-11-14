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

struct CharactersDataWrapper: Decodable, Equatable {

    let data: CharactersDataContainer? //The results returned by the call.

    static func == (lhs: CharactersDataWrapper, rhs: CharactersDataWrapper) -> Bool {

        return lhs.data == rhs.data
    }
}

struct CharactersDataContainer: Decodable, Equatable {

    let results: [Character]? //The list of characters returned by the call.

    static func == (lhs: CharactersDataContainer, rhs: CharactersDataContainer) -> Bool {

        return lhs.results == rhs.results
    }
}

struct Character: Decodable, Equatable {

    let id: Int? //The unique ID of the character resource.,
    let name: String?  //The name of the character.,
    let thumbnail: Image?  //The representative image for this character.

    static func == (lhs: Character, rhs: Character) -> Bool {

        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.thumbnail == rhs.thumbnail
    }
}

struct Image: Decodable, Equatable {

    let path: String? //The directory path of to the image.,
    let extension0: String? //The file extension for the image.

    enum CodingKeys: String, CodingKey {

        case extension0 = "extension"
        case path
    }

    static func == (lhs: Image, rhs: Image) -> Bool {

        return lhs.path == rhs.path && lhs.extension0 == rhs.extension0
    }
}
