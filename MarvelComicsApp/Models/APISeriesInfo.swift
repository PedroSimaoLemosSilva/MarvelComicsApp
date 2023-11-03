//
//  APISeriesInfo.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 03/11/2023.
//

import Foundation

struct SeriesDataWrapper: Decodable, Encodable {

    let data: SeriesDataContainer? //The results returned by the call.
}

struct SeriesDataContainer: Decodable, Encodable {

    let results: [Series]? //The list of characters returned by the call.
}

struct Series: Decodable, Encodable {

    let title: String? //The title of comic,
    let description: String?  //The representative image for this character.
}

