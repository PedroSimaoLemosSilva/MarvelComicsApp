//
//  DetailsViewModel.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 09/11/2023.
//

import Foundation
import UIKit

class DetailsViewModel {

    private let webservice: DetailsWebserviceProtocol

    lazy var characterDetails: [String: [Detail]] = [:]

    private var characterThumbnail: CharacterThumbnail = CharacterThumbnail()

    init(webservice: DetailsWebserviceProtocol = DetailsWebservice(), characterDetails: [String: [Detail]]  = [:], characterThumbnail: CharacterThumbnail = CharacterThumbnail()) {

        self.webservice = webservice
        self.characterDetails = characterDetails
        self.characterThumbnail = characterThumbnail
    }

    var cache = NSCache<NSString, UIImage>()

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

    func getCharacterThumbnail() -> (Int, String, UIImage, Bool) {

        let id = characterThumbnail.id
        let name = characterThumbnail.name
        let image = characterThumbnail.image
        let favourite = characterThumbnail.favourite
        
        return (id, name, image, favourite)
        /*
        if FavouritesSet.sharedInstance.containsFavourite(id: id) {

            guard let newHeart = UIImage(named: "icons8-heart-50 (1).png") else { return nil }

            if let heart = cache.object(forKey: NSString(string: name)) {

                if heart.pngData() == newHeart.pngData() {

                    return (id, name, image, heart)
                } else {

                    cache.setObject(newHeart, forKey: NSString(string: name))
                    return (id, name, image, newHeart)
                }
            } else {

                cache.setObject(newHeart, forKey: NSString(string: name))

                return (id, name, image, newHeart)
            }
        } else {

            guard let newHeart = UIImage(named: "icons8-heart-50.png") else { return nil }

            if let heart = cache.object(forKey: NSString(string: name)) {

                if heart.pngData() == newHeart.pngData() {

                    return (id, name, image, heart)
                } else {

                    cache.setObject(newHeart, forKey: NSString(string: name))
                    return (id, name, image, newHeart)
                }
            } else {

                cache.setObject(newHeart, forKey: NSString(string: name))

                return (id, name, image, newHeart)
            }
        }*/
    }

    func setCharacterThumbnail(id: Int, name: String, image: UIImage, favourite: Bool) {

        self.characterThumbnail = CharacterThumbnail(id: id, name: name, image: image, favourite: favourite)
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

    @objc
    func favouriteChanged() -> Bool {
        
        characterThumbnail.favourite.toggle()
        return self.characterThumbnail.favourite
    }

    func getIconImage() -> UIImage? {

        if self.characterThumbnail.favourite == true {

            return UIImage(named: "icons8-heart-50 (1).png")
        } else {

            return UIImage(named: "icons8-heart-50.png")
        }

    }

    func changeFavourite(id: Int) {

        characterThumbnail.favourite.toggle()
        
        if FavouritesSet.sharedInstance.containsFavourite(id: id) {

            FavouritesSet.sharedInstance.removeFavourite(id: id)
        } else {

            FavouritesSet.sharedInstance.addFavourite(id: id)
        }
    }

    func saveChanges() {

        let array = Array(FavouritesSet.sharedInstance.getFavourites())
        UserDefaults.standard.set(array, forKey: "favouriteId")
    }
}
