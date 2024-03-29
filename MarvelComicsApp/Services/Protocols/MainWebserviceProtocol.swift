//
//  MainWebserviceProtocol.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 13/11/2023.
//

import Foundation

protocol MainWebserviceProtocol {
    
    func resetSearchOffset()

    func fetchCharactersInfo() async throws -> CharactersDataWrapper?
    
    func fetchCharactersInfoSearch(text: String) async throws -> CharactersDataWrapper?

    func fetchCharactersImageData(name: String, url imageUrl: String) async throws -> Data?
}
