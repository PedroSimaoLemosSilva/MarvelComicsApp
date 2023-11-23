//
//  MainViewModel.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 09/11/2023.
//

import Foundation
import UIKit
import Combine

class MainViewModel {

    private let webservice: MainWebserviceProtocol

    private let favourites: FavouritesSet

    lazy var characterThumbnails: [CharacterThumbnail] = []

    //var favouritesId: Set<Int> = []

    var cache = NSCache<NSString, UIImage>()

    init(webservice: MainWebserviceProtocol = MainWebservice(), favourites: FavouritesSet = FavouritesSet(), characterThumbnails: [CharacterThumbnail] = []) {

        self.webservice = webservice
        self.favourites = favourites
        self.characterThumbnails = characterThumbnails
    }

    func numberOfRows() -> Int? {

        return self.characterThumbnails.count
    }

    func characterForRowAt(indexPath: IndexPath) -> (Int, String, UIImage, Bool)? {

        let id = characterThumbnails[indexPath.row].id
        let name = characterThumbnails[indexPath.row].name
        let image = characterThumbnails[indexPath.row].image
        let favourite = characterThumbnails[indexPath.row].favourite

        return (id, name, image, favourite)
    }

    func characterForRowAtImage(indexPath: IndexPath) -> (Int, String, UIImage, UIImage)? {

        let id = characterThumbnails[indexPath.row].id
        let name = characterThumbnails[indexPath.row].name
        let image = characterThumbnails[indexPath.row].image

        if characterThumbnails[indexPath.row].favourite {

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
        }
    }

    func changeFavourite(id: Int) {

        if let characterThumbnail = characterThumbnails.first(where: {$0.id == id}) {

            characterThumbnail.favourite.toggle()

            if characterThumbnail.favourite {

                favourites.addFavourite(id: id)
            } else {

                favourites.removeFavourite(id: id)
            }
        } else {

            if favourites.containsFavourite(id: id) {

                favourites.addFavourite(id: id)
            } else {

                favourites.removeFavourite(id: id)
            }
        }
    }

    func modifyFavouriteId(id: Int) {

        if let characterThumbnail = characterThumbnails.first(where: {$0.id == id}) {

            if characterThumbnail.favourite {

                favourites.addFavourite(id: id)
            } else {

                favourites.removeFavourite(id: id)
            }
        } else {

            if favourites.containsFavourite(id: id) {

                favourites.removeFavourite(id: id)
            } else {

                favourites.addFavourite(id: id)
            }
        }
    }
    
    func dataLoad() async {
        
        do {

            guard let characterDataWrapper = try await webservice.fetchCharactersInfo(),
                  let charactersData = characterDataWrapper.data?.results else { return }

            for character in charactersData {

                guard let id = character.id,
                      let name = character.name,
                      let path = character.thumbnail?.path,
                      let ext = character.thumbnail?.extension0 else { return }

                let imageUrl = path + "." + ext

                guard let imageData = try await webservice.fetchCharactersImageData(name: name,url: imageUrl) else { return }

                guard let image = UIImage(data: imageData) else { return }

                let characterThumbnail = CharacterThumbnail(id: id, name: name, image: image, favourite: false)

                characterThumbnails.append(characterThumbnail)
            }
        } catch { print(error) }
    }

    func filterFavourites() -> [CharacterThumbnail] {

        let favouriteThumbnails = characterThumbnails.filter { characterThumbnail in

            if characterThumbnail.favourite {

                return true
            } else {

                return false
            }
        }

        return favouriteThumbnails
    }


    func loadAllFavourites() {
        
        guard let auxfFavouritesId = UserDefaults.standard.object(forKey: "favouriteId") as? [Int] else {

            return
        }

        favourites.setFavourites(favourites: Set(auxfFavouritesId))

        setAllFavourites()
    }

    func setAllFavourites() {

        favourites.getFavourites().forEach { id in

            if let characterThumbnail = characterThumbnails.first(where: {$0.id == id}) {

                characterThumbnail.favourite = true
            }
        }
    }

    func saveChanges() {

        let array = Array(favourites.getFavourites())
        UserDefaults.standard.set(array, forKey: "favouriteId")
    }

    func getFavourites() -> Set<Int> {

        return self.favourites.getFavourites()
    }
}
