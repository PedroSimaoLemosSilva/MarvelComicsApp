//
//  DetailsViewModel.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 09/11/2023.
//

import Foundation
import UIKit

class DetailsViewModel {

    private let webservice = DetailsWebservice()

    private lazy var characterDetails: [String: [Detail]] = [:]

    private var characterThumbnail: CharacterThumbnail = CharacterThumbnail()

    func dataFormatting() async {

        do {

            guard let comicsDataWrapper = try await webservice.fetchComics(id: characterThumbnail.id),
                  let eventsDataWrapper = try await webservice.fetchEvents(id: characterThumbnail.id),
                  let seriesDataWrapper = try await webservice.fetchSeries(id: characterThumbnail.id),
                  let storiesDataWrapper = try await webservice.fetchStories(id: characterThumbnail.id) else { return }

            characterDetails["Character"] = [Detail(title: "", description: "")]

            if let comicsData = comicsDataWrapper.data?.results {

                characterDetails["Comics"] = comicsData
            } else { characterDetails["Comics"] = nil }

            if let eventsData = eventsDataWrapper.data?.results {

                characterDetails["Events"] = eventsData
            } else { characterDetails["Events"] = nil }

            if let seriesData = seriesDataWrapper.data?.results {

                characterDetails["Series"] = seriesData
            } else { characterDetails["Series"] = nil  }

            if let storiesData = storiesDataWrapper.data?.results {

                characterDetails["Stories"] = storiesData
            } else { characterDetails["Stories"] = nil  }
            
        } catch { print(error) }
    }

    func getCharacterThumbnail() -> (Int, String, UIImage) {

        let id = characterThumbnail.id
        let name = characterThumbnail.name
        let image = characterThumbnail.image

        return (id, name, image)
    }

    func setCharacterThumbnail(id: Int, name: String, image: UIImage) {

        self.characterThumbnail = CharacterThumbnail(id: id, name: name, image: image)
    }

    func getCharacterDetailsKeys() -> [String] {

        return Array(characterDetails.keys).map { String($0) }.sorted { $0 < $1 }
    }

    func characterForRowAtSectionAt(indexPath: IndexPath, key: String) -> (String, String) {

        guard let title = characterDetails[key]?[indexPath.row].title else { return ("","") }

        let description = characterDetails[key]?[indexPath.row].description
        return (title, description ?? "")
    }

    func numberOfSections() -> Int {

        return self.characterDetails.count
    }

    func numberOfRowsInSection(section: String) -> Int? {

        let numberOfRowsInSection = characterDetails[section]?.count

        return numberOfRowsInSection
    }
}
