//
//  FavouritesSet.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 21/11/2023.
//

import Foundation

class FavouritesSet {

    static let sharedInstance = FavouritesSet()

    private var favourites: Set<Int>

    init() {

        self.favourites = []
    }

    init(favourites: Set<Int>) {

        self.favourites = favourites
    }

    init(_ instance: FavouritesSet) {

        self.favourites = instance.favourites
    }

    func getFavourites() -> Set<Int> {

        return self.favourites
    }

    func setFavourites(favourites: Set<Int>) {
        
        self.favourites = favourites
    }

    func addFavourite(id: Int) {

        self.favourites.insert(id)
    }

    func removeFavourite(id: Int) {

        self.favourites.remove(id)
    }

    func countFavourite() -> Int {

        return self.favourites.count
    }

    func containsFavourite(id: Int) -> Bool {

        return self.favourites.contains(id)
    }
}
