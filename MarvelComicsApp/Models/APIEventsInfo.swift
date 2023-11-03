//
//  APIEventsInfo.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 03/11/2023.
//

import Foundation

struct EventsDataWrapper: Decodable, Encodable {

    let data: EventsDataContainer? //The results returned by the call.
}

struct EventsDataContainer: Decodable, Encodable {

    let results: [Event]? //The list of characters returned by the call.
}

struct Event: Decodable, Encodable {

    let title: String? //The title of comic,
    let description: String?  //The representative image for this character.
}
