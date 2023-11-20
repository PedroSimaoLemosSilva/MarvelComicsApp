//
//  MockedFavouritesWebservice.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 20/11/2023.
//

import Foundation

class MockedFavouritesWebservice: FavouritesWebserviceProtocol {

    var fetchCharactersMockResult: CharactersDataWrapper?

    var fetchCharactersImageData: Data?

    func fetchCharacter(id: Int) async throws -> CharactersDataWrapper? {

        if let result = fetchCharactersMockResult {

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
