//
//  APIStoriesInfo.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 03/11/2023.
//

import Foundation

struct StoriesDataWrapper: Decodable, Encodable {

    let data: StoriesDataContainer? //The results returned by the call.
}

struct StoriesDataContainer: Decodable, Encodable {

    let results: [Story]? //The list of characters returned by the call.
}

struct Story: Decodable, Encodable {

    let title: String? //The title of comic,
    let description: String?  //The representative image for this character.
}
