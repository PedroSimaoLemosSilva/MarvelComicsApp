//
//  Webservices.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 26/10/2023.
//

import Foundation

class Webservice {

    func fetchCharacterDataWrapper(url: URL?) async throws -> CharactersDataWrapper? {

        guard let url = url else {

            return nil
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let marvelData = try? JSONDecoder().decode(CharactersDataWrapper.self, from: data)

        return marvelData
    }

    // fetches the characters names and thumbnail images into a sorted dictionary
    // where the names are the keys and the full image paths are the values
    func fetchCharactersInfo(url: URL?) async throws -> CharactersDataWrapper? {

        guard let url = url else {

            return nil
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let characterDataWrapper = try? JSONDecoder().decode(CharactersDataWrapper.self, from: data)

        return characterDataWrapper
    }

    func fetchDetailsInfo(url: URL?) async throws -> DetailsDataWrapper? {

        guard let url = url else {

            return nil
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let detailsDataWrapper = try? JSONDecoder().decode(DetailsDataWrapper.self, from: data)

        return detailsDataWrapper
    }
}
