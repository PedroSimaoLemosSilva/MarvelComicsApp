//
//  FavouritesWebserviceProtocol.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 17/11/2023.
//

import Foundation

protocol FavouritesWebserviceProtocol {

    func fetchCharacter(id: Int) async throws -> CharactersDataWrapper?

    func fetchCharactersImageData(name: String, url imageUrl: String) async throws -> Data?
}
