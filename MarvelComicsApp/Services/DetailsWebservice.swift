//
//  DetailsWebservice.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 07/11/2023.
//

import Foundation

class DetailsWebservice: DetailsWebserviceProtocol {

    private let id = 0

    private var urls = Urls()

    func fetchComics(id: Int) async throws -> DetailsDataWrapper? {

        guard let url = urls.getComicsUrl(id: id) else {

            return nil
        }

        return try await fetchData(url: url)
    }

    func fetchEvents(id: Int) async throws -> DetailsDataWrapper? {

        guard let url = urls.getEventsUrl(id: id) else {

            return nil
        }

        return try await fetchData(url: url)
    }

    func fetchSeries(id: Int) async throws -> DetailsDataWrapper? {

        guard let url = urls.getSeriesUrl(id: id) else {

            return nil
        }

        return try await fetchData(url: url)
    }
    
    func fetchStories(id: Int) async throws -> DetailsDataWrapper? {

        guard let url = urls.getStories(id: id) else {

            return nil
        }

        return try await fetchData(url: url)
    }

    func fetchData(url: URL) async throws -> DetailsDataWrapper? {

        let (data, _) = try await URLSession.shared.data(from: url)

        let detailsDataWrapper = try? JSONDecoder().decode(DetailsDataWrapper.self, from: data)

        return detailsDataWrapper
    }
}
