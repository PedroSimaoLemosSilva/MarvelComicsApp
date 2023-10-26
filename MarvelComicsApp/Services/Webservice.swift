//
//  Webservices.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 26/10/2023.
//

import Foundation

class Webservice {

    func fetchCharacterDataWrapper(url: URL?) async throws -> [CharacterDataWrapper] {

        guard let url = url else {
            return []
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let marvelData = try? JSONDecoder().decode(MarvelData.self, from: data)

        return marvelData?.wrappers ?? []
    }
}
