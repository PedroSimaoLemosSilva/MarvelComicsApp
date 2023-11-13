//
//  Webservices.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 26/10/2023.
//

import Foundation

class MainWebservice {

    private var offset = 0

    private var urls = Urls()

    // fetches the characters names and thumbnail images into a sorted dictionary
    // where the names are the keys and the full image paths are the values
    func fetchCharactersInfo() async throws -> CharactersDataWrapper? {

        let url: URL
        if self.offset == 0 {

            guard let newUrl = Urls.charactersFirstLoadUrl else {

                return nil
            }
            url = newUrl
        } else {

            guard let newUrl = urls.getCharactersLoadMoreUrl(offset: self.offset) else {

                return nil
            }
            url = newUrl
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let characterDataWrapper = try? JSONDecoder().decode(CharactersDataWrapper.self, from: data)

        self.offset += 20

        return characterDataWrapper
    }

    func fetchCharactersImageData(name: String, url imageUrl: String) async throws -> Data {

        var data = Data()

        guard let url = URL(string: imageUrl) else { return(data) }

        (data, _) = try await URLSession.shared.data(from: url)

        return data
    }
}


