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

    private var favouriteIds: FavouritesSet = FavouritesSet.sharedInstance

    lazy var characterThumbnails: [CharacterThumbnail] = []
    
    lazy var characterThumbnailsSearch: [CharacterThumbnail] = []
    
    private var text: String = ""
    
    private var searchState: Bool = false

    private var doneLoaded: Bool = false

    private var doneLoadedSearch: Bool = false

    var task: Task<(), Never>? = nil

    //var cache = NSCache<NSString, UIImage>()

    init(webservice: MainWebserviceProtocol = MainWebservice(), favouriteIds : FavouritesSet = FavouritesSet.sharedInstance, characterThumbnails: [CharacterThumbnail] = [],
         characterThumbnailsSearch: [CharacterThumbnail] = [], text: String = "", searchState: Bool = false, doneLoaded: Bool = false, doneLoadedSearch: Bool = false, task: Task<(), Never>? = nil) {

        self.webservice = webservice
        self.favouriteIds = favouriteIds
        self.characterThumbnails = characterThumbnails
        self.characterThumbnailsSearch = characterThumbnailsSearch
        self.text = text
        self.searchState = searchState
        self.doneLoaded = doneLoaded
        self.doneLoadedSearch = doneLoadedSearch
        self.task = task
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

            if let characterThumbnail = characterThumbnails.first(where: {$0.id == id}) {

                characterThumbnail.favourite.toggle()
            }
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

            if searchState {

                if charactersData.count == 0 {

                    self.doneLoadedSearch = true
                } else {

                    self.doneLoadedSearch = false
                }
            } else {

                if charactersData.count == 0 {

                    self.doneLoaded = true
                } else {

                    self.doneLoaded = false
                }
            }

            for character in charactersData {

                guard let id = character.id,
                      let name = character.name,
                      let path = character.thumbnail?.path,
                      let ext = character.thumbnail?.extension0 else { return }

                let imageUrl = path + "." + ext
                
                var auxImage = UIImage()

                if imageUrl == "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg" {

                    guard let image = UIImage(named: "place-holder") else { return }

                    auxImage = image
                } else {

                    guard let imageData = try await webservice.fetchCharactersImageData(name: name,url: imageUrl) else { return }

                    guard let image = UIImage(data: imageData) else { return }

                    auxImage = image
                }

                let characterThumbnail = CharacterThumbnail(id: id, name: name, image: auxImage, favourite: false)

                if searchState {
                    
                    self.characterThumbnailsSearch.append(characterThumbnail)
                } else {
                    
                    self.characterThumbnails.append(characterThumbnail)
                }
            }
        } catch { print(error) }

        //characterThumbnails.sort(by: { $0.name < $1.name })
    }

    @MainActor
    func dataLoadSearch() async {
        
        do {
            
            guard let characterDataWrapper = try await webservice.fetchCharactersInfoSearch(text: self.text),
                  let charactersData = characterDataWrapper.data?.results else { return }

            if searchState {

                if charactersData.count == 0 {
                    
                    self.doneLoadedSearch = true
                
                } else {

                    self.doneLoadedSearch = false
                }
            } else {

                if charactersData.count == 0 {

                    self.doneLoaded = true
                } else {

                    self.doneLoaded = false
                }
            }

            for character in charactersData {

                guard let id = character.id,
                      let name = character.name,
                      let path = character.thumbnail?.path,
                      let ext = character.thumbnail?.extension0 else { return }

                let imageUrl = path + "." + ext

                var auxImage = UIImage()

                if imageUrl == "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available.jpg" {

                    guard let image = UIImage(named: "place-holder") else { return }

                    auxImage = image
                } else {

                    guard let imageData = try await webservice.fetchCharactersImageData(name: name,url: imageUrl) else { return }

                    guard let image = UIImage(data: imageData) else { return }

                    auxImage = image
                }

                let characterThumbnail = CharacterThumbnail(id: id, name: name, image: auxImage, favourite: false)

                if searchState {
                    
                    self.characterThumbnailsSearch.append(characterThumbnail)
                } else {
                    
                    self.characterThumbnails.append(characterThumbnail)
                }
            }
        } catch { print(error) }

        //characterThumbnails.sort(by: { $0.name < $1.name })
    }

    func filterFavourites() -> [CharacterThumbnail] {

        var favouriteThumbnails = filterFavouritesFromArray(array: characterThumbnails)
        
        var favouriteThumbnailsSearch: [CharacterThumbnail] = []
        if searchState {

            favouriteThumbnailsSearch = filterFavouritesFromArray(array: characterThumbnailsSearch)

            for character in characterThumbnails {

                if let indexOfCharacterThumbnail = favouriteThumbnailsSearch.firstIndex(where: {$0.id == character.id}) {

                    favouriteThumbnailsSearch.remove(at: indexOfCharacterThumbnail)
                }
            }
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

    func getText() -> String {

        return self.text
    }

    func setText(text: String) {
        
        self.text = text
    }
    
    func resetCharacterThumbnailsSearch() {

        self.characterThumbnailsSearch = []
        self.webservice.resetSearchOffset()
    }

    func getDoneLoaded() -> Bool {

        return self.doneLoaded
    }

    func getDoneLoadedSearch() -> Bool {

        return self.doneLoadedSearch
    }

    func setDoneLoaded(doneLoaded: Bool){

        self.doneLoaded = doneLoaded
    }

    func setDoneLoadedSearch(doneLoadedSearch: Bool) {

         self.doneLoadedSearch = doneLoadedSearch
    }
}

