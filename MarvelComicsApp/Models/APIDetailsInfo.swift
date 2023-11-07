//
//  APIComicsInfo.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 03/11/2023.
//

import Foundation

struct DetailsDataWrapper: Decodable, Encodable {

    let data: DetailsDataContainer? //The results returned by the call.
}

struct DetailsDataContainer: Decodable, Encodable {

    let results: [Detail]? //The list of characters returned by the call.
}

struct Detail: Decodable, Encodable {

    let title: String? //The title of comic,
    let description: String?  //The representative image for this character.
}
