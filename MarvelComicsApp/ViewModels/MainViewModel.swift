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

    private let favouriteIds: FavouritesSet = FavouritesSet.sharedInstance

    lazy var characterThumbnails: [CharacterThumbnail] = []
    
    lazy var characterThumbnailsSearch: [CharacterThumbnail] = []
    
    private var text: String = ""
    
    private var searchState: Bool = false

    //var cache = NSCache<NSString, UIImage>()

    init(webservice: MainWebserviceProtocol = MainWebservice(), characterThumbnails: [CharacterThumbnail] = []) {

        self.webservice = webservice
        self.characterThumbnails = characterThumbnails
    }

    func numberOfRows() -> Int? {
        
        if searchState {
            
            return self.characterThumbnailsSearch.count
        } else {
            
            return self.characterThumbnails.count
        }
    }

    func characterForRowAt(indexPath: IndexPath) -> (Int, String, UIImage, Bool) {
        
        if searchState {
            
            return getCharacterForRowAt(indexPath: indexPath, array: characterThumbnailsSearch)
        } else {
            
            return getCharacterForRowAt(indexPath: indexPath, array: characterThumbnails)
        }
    }
    
    func getCharacterForRowAt(indexPath: IndexPath, array: [CharacterThumbnail]) -> (Int, String, UIImage, Bool) {
        
        let id = array[indexPath.row].id
        let name = array[indexPath.row].name
        let image = array[indexPath.row].image
        let favourite = array[indexPath.row].favourite
        
        return (id, name, image, favourite)
    }

    func changeFavourite(id: Int) {

        if searchState {
            
            self.changeFavouriteForArray(id: id, array: characterThumbnailsSearch)
        } else {
            
            self.changeFavouriteForArray(id: id, array: characterThumbnails)
        }
    }
    
    func changeFavouriteForArray(id: Int, array: [CharacterThumbnail]) {
        
        if let characterThumbnail = array.first(where: {$0.id == id}) {

            characterThumbnail.favourite.toggle()

            if characterThumbnail.favourite {

                favouriteIds.addFavourite(id: id)
            } else {

                favouriteIds.removeFavourite(id: id)
            }
        } else {

            if favouriteIds.containsFavourite(id: id) {

                favouriteIds.addFavourite(id: id)
            } else {

                favouriteIds.removeFavourite(id: id)
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

                if searchState {
                    
                    self.characterThumbnailsSearch.append(characterThumbnail)
                } else {
                    
                    self.characterThumbnails.append(characterThumbnail)
                }
            }
        } catch { print(error) }
    }
    
    func dataLoadSearch() async {
        
        do {
            
            guard let characterDataWrapper = try await webservice.fetchCharactersInfoSearch(text: self.text),
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

                if searchState {
                    
                    self.characterThumbnailsSearch.append(characterThumbnail)
                } else {
                    
                    self.characterThumbnails.append(characterThumbnail)
                }
            }
        } catch { print(error) }
    }

    func filterFavourites() -> [CharacterThumbnail] {

        var favouriteThumbnails = filterFavouritesFromArray(array: characterThumbnails)
        
        var favouriteThumbnailsSearch: [CharacterThumbnail] = []
        if searchState {
            
            favouriteThumbnailsSearch = filterFavouritesFromArray(array: characterThumbnailsSearch)
        }
        
        favouriteThumbnails.append(contentsOf: favouriteThumbnailsSearch)
        
        return favouriteThumbnails
    }

    func filterFavouritesFromArray(array: [CharacterThumbnail]) -> [CharacterThumbnail] {
        
        return array.filter { characterThumbnail in
            
            if characterThumbnail.favourite {

                return true
            } else {

                return false
            }
        }
    }

    func loadAllFavourites() {
        
        guard let auxfFavouritesId = UserDefaults.standard.object(forKey: "favouriteId") as? [Int] else {

            return
        }

        favouriteIds.setFavourites(favourites: Set(auxfFavouritesId))

        setAllFavourites()
    }

    func setAllFavourites() {

        favouriteIds.getFavourites().forEach { id in
            
            if searchState {
                print(characterThumbnailsSearch)
                if let characterThumbnail = characterThumbnailsSearch.first(where: {$0.id == id}) {
                    
                    characterThumbnail.favourite = true
                    
                }
            } else {
                
                if let characterThumbnail = characterThumbnails.first(where: {$0.id == id}) {

                    characterThumbnail.favourite = true
                }
            }
        }
    }

    func saveChanges() {

        let array = Array(favouriteIds.getFavourites())
        UserDefaults.standard.set(array, forKey: "favouriteId")
    }

    func getFavourites() -> Set<Int> {

        return self.favouriteIds.getFavourites()
    }
    
    func changeState() {
        
        self.searchState.toggle()
    }
    
    func getState() -> Bool {
        
        return self.searchState
    }
    
    func setText(text: String) {
        
        self.text = text
    }
    
    func resetCharacterThumbnailsSearch() {
        
        self.characterThumbnailsSearch = []
        self.webservice.resetSearchOffset()
    }
}

