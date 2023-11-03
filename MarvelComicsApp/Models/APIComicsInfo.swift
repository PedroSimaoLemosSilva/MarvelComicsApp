//
//  APIComicsInfo.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 03/11/2023.
//

import Foundation

struct ComicsDataWrapper: Decodable, Encodable {

    let data: ComicsDataContainer? //The results returned by the call.
}

struct ComicsDataContainer: Decodable, Encodable {

    let results: [Comic]? //The list of characters returned by the call.
}

struct Comic: Decodable, Encodable {

    let title: String? //The title of comic,
    let description: String?  //The representative image for this character.
}
