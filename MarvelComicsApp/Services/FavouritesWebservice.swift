//
//  FavouritesWebservice.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 17/11/2023.
//

import Foundation

class FavouritesWebservice: FavouritesWebserviceProtocol {

    private var urls = Urls()

    func fetchCharacter(id: Int) async throws -> CharactersDataWrapper? {

        guard let url = urls.getCharacter(id: id) else {

            return nil
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let characterDataWrapper = try? JSONDecoder().decode(CharactersDataWrapper.self, from: data)

        return characterDataWrapper
    }

    func fetchCharactersImageData(name: String, url imageUrl: String) async throws -> Data? {

        var data = Data()

        guard let url = URL(string: imageUrl) else { return nil }

        (data, _) = try await URLSession.shared.data(from: url)

        return data
    }

}
