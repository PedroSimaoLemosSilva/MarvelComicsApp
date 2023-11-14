//
//  MockedMainService.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 13/11/2023.
//

import Foundation

class MockedMainWebservice: MainWebserviceProtocol {

    var fetchCharactersInfoMockResult: CharactersDataWrapper?

    var fetchCharactersImageData: Data?

    // fetches the characters names and thumbnail images into a sorted dictionary
    // where the names are the keys and the full image paths are the values
    func fetchCharactersInfo() async throws -> CharactersDataWrapper? {

        if let result = fetchCharactersInfoMockResult {

            return result
        } else {

            return nil
        }
    }

    func fetchCharactersImageData(name: String, url imageUrl: String) async throws -> Data? {

        if let result = fetchCharactersImageData {

            return result
        } else {

            return nil
        }
    }
}
