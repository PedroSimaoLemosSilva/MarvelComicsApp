//
//  MockedMainService.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 13/11/2023.
//

import Foundation

class MockedMainWebservice: MainWebserviceProtocol {

    var fetchCharactersInfoMockResult: CharactersDataWrapper?
    
    var fetchCharactersInfoSearchMockResult: CharactersDataWrapper?

    var fetchCharactersImageData: Data?

    func fetchCharactersInfo() async throws -> CharactersDataWrapper? {

        if let result = fetchCharactersInfoMockResult {

            return result
        } else {

            return nil
        }
    }
    
    func fetchCharactersInfoSearch(text: String) async throws -> CharactersDataWrapper? {

        if let result = fetchCharactersInfoSearchMockResult {

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
