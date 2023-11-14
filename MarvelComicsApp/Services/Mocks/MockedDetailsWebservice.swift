//
//  MockedDetailsWebservice.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 13/11/2023.
//

import Foundation

class MockedDetailsWebservice: DetailsWebserviceProtocol {

    var fetchComicsMockResults: DetailsDataWrapper?
    var fetchEventsMockResults: DetailsDataWrapper?
    var fetchSeriesMockResults: DetailsDataWrapper?
    var fetchStoriesMockResults: DetailsDataWrapper?
    var fetchDataMockResults: DetailsDataWrapper?

    func fetchComics(id: Int) async throws -> DetailsDataWrapper? {

        if let result = fetchComicsMockResults {

            return result
        } else {

            return nil
        }
    }

    func fetchEvents(id: Int) async throws -> DetailsDataWrapper? {

        if let result = fetchEventsMockResults {

            return result
        } else {

            return nil
        }
    }

    func fetchSeries(id: Int) async throws -> DetailsDataWrapper? {

        if let result = fetchSeriesMockResults {

            return result
        } else {

            return nil
        }
    }

    func fetchStories(id: Int) async throws -> DetailsDataWrapper? {

        if let result = fetchStoriesMockResults {

            return result
        } else {

            return nil
        }
    }

    func fetchData(url: URL) async throws -> DetailsDataWrapper? {

        return nil
    }
}

