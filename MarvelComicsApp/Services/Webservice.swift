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

    // fetches the characters names and thumbnail images into a sorted dictionary
    // where the names are the keys and the full image paths are the values
    func fetchCharactersNameThumbnailPath(url: URL?) async throws -> [[(String, String)]] {

        guard let url = url else {

            return []
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        let marvelData = try? JSONDecoder().decode(CharacterDataWrapper.self, from: data)

        var array: [[(String, String)]] = []
        var subArray: [(String, String)] = []
        if let comicsCharacters = marvelData?.data?.results {
            var i = 0
            for comicsCharacter in comicsCharacters {

                if let name = comicsCharacter.name,
                   let thumbnailPath = comicsCharacter.thumbnail?.path,
                   let thumbnailExtension = comicsCharacter.thumbnail?.extension0{

                    let fullPath = thumbnailPath + "/portrait_xlarge." + thumbnailExtension

                    subArray.append((name, fullPath))

                    i += 1

                    if subArray.count == 4 {

                        let auxArray = subArray

                        subArray = []
                        array.append(auxArray)
                    }
                }
            }
        }

        return array
    }
}
