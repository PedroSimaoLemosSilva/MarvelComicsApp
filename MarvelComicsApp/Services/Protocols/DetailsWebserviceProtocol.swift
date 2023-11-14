//
//  DetailsWebserviceProtocol.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 13/11/2023.
//

import Foundation
import UIKit

protocol DetailsWebserviceProtocol {

    func fetchComics(id: Int) async throws -> DetailsDataWrapper?

    func fetchEvents(id: Int) async throws -> DetailsDataWrapper?

    func fetchSeries(id: Int) async throws -> DetailsDataWrapper?

    func fetchStories(id: Int) async throws -> DetailsDataWrapper?

    func fetchData(url: URL) async throws -> DetailsDataWrapper? 
}
