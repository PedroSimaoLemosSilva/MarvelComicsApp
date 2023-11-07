//
//  Constants.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 26/10/2023.
//

import Foundation
import CryptoKit

struct Constants {

    struct Urls {

        static let apiTime = String.dateNowtoString()
        static let apiPublicKey = "bf3a93c4a0fd6dc17fdbba86491f5056"
        static let apiPrivateKey = "7dab1e2e48699e1386166e4a7c1e40ea28cd6a46"
        static let hash = apiTime + apiPrivateKey + apiPublicKey
        static let apiHash = String.MD5(string: hash)

        var id: Int

        static let characters: URL? = URL(string: "https://gateway.marvel.com/v1/public/characters?limit=20&ts=\(apiTime)&apikey=\(apiPublicKey)&hash=\(apiHash)")
        lazy var comics: URL? = URL(string: "https://gateway.marvel.com/v1/public/characters/\(self.id)/comics?limit=3&ts=\(Constants.Urls.apiTime)&apikey=\(Constants.Urls.apiPublicKey)&hash=\(Constants.Urls.apiHash)")
        lazy var events: URL? = URL(string: "https://gateway.marvel.com/v1/public/characters/\(self.id)/events?limit=3&ts=\(Constants.Urls.apiTime)&apikey=\(Constants.Urls.apiPublicKey)&hash=\(Constants.Urls.apiHash)")
        lazy var series: URL? = URL(string: "https://gateway.marvel.com/v1/public/characters/\(self.id)/series?limit=3&ts=\(Constants.Urls.apiTime)&apikey=\(Constants.Urls.apiPublicKey)&hash=\(Constants.Urls.apiHash)")
        lazy var stories: URL? = URL(string: "https://gateway.marvel.com/v1/public/characters/\(self.id)/stories?limit=3&ts=\(Constants.Urls.apiTime)&apikey=\(Constants.Urls.apiPublicKey)&hash=\(Constants.Urls.apiHash)")

        init(id: Int) {

            self.id = id
        }
    }
}

extension String {

    static func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: Data(string.utf8))

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }

    static func dateNowtoString() -> String {

        let today = Date.now
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: today)
    }
}
