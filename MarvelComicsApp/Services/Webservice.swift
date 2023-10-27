//
//  Webservices.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 26/10/2023.
//

import Foundation

class Webservice {

    func fetchCharacterDataWrapper(url: URL?) async throws -> CharacterDataWrapper? {

        guard let url = url else {

            return nil
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let marvelData = try? JSONDecoder().decode(CharacterDataWrapper.self, from: data)

        //print(String(data: data, encoding: .utf8)) // does the job

        return marvelData
    }

    func fetchCharactersNameThumbnailPath(url: URL?) async throws -> [String: String] {

        guard let url = url else {

            return [:]
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let marvelData = try? JSONDecoder().decode(CharacterDataWrapper.self, from: data)

        var characterDict = [String: String]()
        if let comicsCharacters = marvelData?.data?.results {

            for comicsCharacter in comicsCharacters {

                if let name = comicsCharacter.name,
                   let thumbnailPath = comicsCharacter.thumbnail?.path {

                    characterDict[name] = thumbnailPath
                }
            }
        }

        return characterDict
    }

    
}
