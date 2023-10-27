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

struct CharacterDataWrapper: Decodable, Encodable {

    let code : Int? //The HTTP status code of the returned result.
    let status: String? //A string description of the call status.
    let copyright: String? //The copyright notice for the returned result.
    let attributionText: String? //The attribution notice for this result.
    let attributionHTML: String? //An HTML representation of the attribution notice for this result.
    let etag: String? //A digest value of the content returned by the call.
    let data: CharacterDataContainer? //The results returned by the call.
}

struct CharacterDataContainer: Decodable, Encodable {

    let offset: Int? //The requested offset (number of skipped results) of the call.,
    let limit: Int? //The requested result limit.,
    let total: Int? //The total number of resources available given the current filter set.,
    let count: Int? //The total number of results returned by this call.,
    let results: [Character]? //The list of characters returned by the call.
}

struct Character: Decodable, Encodable {

    let id: Int? //The unique ID of the character resource.,
    let name: String?  //The name of the character.,
    let description: String? //A short bio or description of the character.,
    let modified: String? //The date the resource was most recently modified.,
    let thumbnail: Image?  //The representative image for this character.,
    let resourceURI: String? //The canonical URL identifier for this resource.,
    let comics: ComicList  //A resource list containing comics which feature this character.,
    let stories: StoryList  //A resource list of stories in which this character appears.,
    let events: EventList  //A resource list of events in which this character appears.,
    let series: SeriesList //A resource list of series in which this character appears.,
    let urls: [Url]?  //A set of public web site URLs for the resource.
}

struct Url: Decodable, Encodable {

    let type: String? //A text identifier for the URL.,
    let url: String? //A full URL (including scheme, domain, and path).
}

struct Image: Decodable, Encodable {

    let path: String? //The directory path of to the image.,
    let ´extension´: String? //The file extension for the image.
    /*
    enum CodingKeys: String, CodingKey {

        case extension0 = "extension"
        case path
    } */
}

struct ComicList: Decodable, Encodable {

    let available: Int? //The number of total available issues in this list. Will always be greater than or equal to the "returned" value.,
    let collectionURI: String? //The path to the full list of issues in this collection.,
    let items: [ComicSummary]? //The list of returned issues in this collection.,
    let returned: Int? //The number of issues returned in this collection (up to 20).
}

struct ComicSummary: Decodable, Encodable {

    let resourceURI: String? //The path to the individual comic resource.,
    let name: String? //The canonical name of the comic.
}

struct StoryList: Decodable, Encodable {

    let available: Int? //The number of total available stories in this list. Will always be greater than or equal to the "returned" value.
    let collectionURI: String? //The path to the full list of stories in this collection.
    let items: [StorySummary]? //The list of returned stories in this collection.
    let returned: Int? //The number of stories returned in this collection (up to 20).
}

struct StorySummary: Decodable, Encodable {

    let resourceURI: String? //The path to the individual story resource.,
    let name: String? //The canonical name of the story.,
    let type: String? //The type of the story (interior or cover).
}
struct EventList: Decodable, Encodable {

    let available: Int? //The number of total available events in this list. Will always be greater than or equal to the "returned" value.,
    let collectionURI: String? //The path to the full list of events in this collection.,
    let items: [EventSummary]? //The list of returned events in this collection.,
    let returned: Int? //The number of events returned in this collection (up to 20).
}

struct EventSummary: Decodable, Encodable  {

    let resourceURI: String? //The path to the individual event resource.,
    let name: String? //The name of the event.
}

struct SeriesList: Decodable, Encodable  {

    let available: Int? //The number of total available series in this list. Will always be greater than or equal to the "returned" value.,
    let returned: Int? //The number of series returned in this collection (up to 20).
    let items: [SeriesSummary]? //The list of returned series in this collection.,
    let collectionURI: String? //The path to the full list of series in this collection.
}

struct SeriesSummary: Decodable, Encodable  {

    let resourceURI: String? //The path to the individual series resource.,
    let name: String? //The canonical name of the series.
}
