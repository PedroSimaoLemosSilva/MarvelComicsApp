//
//  Webservices.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 26/10/2023.
//

import Foundation

class MainWebservice: MainWebserviceProtocol {

    private var offset = 0
    
    private var searchOffset = 0

    private var urls = Urls()

    func fetchCharactersInfo() async throws -> CharactersDataWrapper? {

        let url: URL

        guard let newUrl = urls.getCharactersUrl(offset: self.offset) else {

            return nil
        }
        url = newUrl
        
        let (data, _) = try await URLSession.shared.data(from: url)

        let characterDataWrapper = try? JSONDecoder().decode(CharactersDataWrapper.self, from: data)

        self.offset += 20
        
        return characterDataWrapper
    }
    
    func fetchCharactersInfoSearch(text: String) async throws -> CharactersDataWrapper? {
        
        let url: URL

        guard let newUrl = urls.getCharactersUrlSearch(text: text, offset: self.searchOffset) else {

            return nil
        }
        url = newUrl

        let (data, _) = try await URLSession.shared.data(from: url)

        let characterDataWrapper = try? JSONDecoder().decode(CharactersDataWrapper.self, from: data)

        self.searchOffset += 20

        return characterDataWrapper
    }

    func fetchCharactersImageData(name: String, url imageUrl: String) async throws -> Data? {

        var data = Data()

        guard let url = URL(string: imageUrl) else { return nil }

        (data, _) = try await URLSession.shared.data(from: url)

        return data
    }
}


