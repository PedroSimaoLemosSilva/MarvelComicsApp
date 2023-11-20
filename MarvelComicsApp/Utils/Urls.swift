//
//  swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 26/10/2023.
//

import Foundation
import CryptoKit

class Urls {

    static let apiTime = String.dateNowtoString()
    static let apiPublicKey = "bf3a93c4a0fd6dc17fdbba86491f5056"
    static let apiPrivateKey = "7dab1e2e48699e1386166e4a7c1e40ea28cd6a46"
    static let hash = apiTime + apiPrivateKey + apiPublicKey
    static let apiHash = String.MD5(string: hash)

    static let charactersFirstLoadUrl: URL? = URL(string: "https://gateway.marvel.com/v1/public/characters?limit=20&ts=\(apiTime)&apikey=\(apiPublicKey)&hash=\(apiHash)")

    func getCharactersLoadMoreUrl(offset: Int) -> URL? {

        let url = URL(string: "https://gateway.marvel.com/v1/public/characters?limit=20&offset=\(offset)&ts=\(Urls.apiTime)&apikey=\(Urls.apiPublicKey)&hash=\(Urls.apiHash)")
        return url
    }

    func getCharacter(id: Int) -> URL? {

        let url = URL(string: "https://gateway.marvel.com/v1/public/characters/\(id)?limit=3&ts=\(Urls.apiTime)&apikey=\(Urls.apiPublicKey)&hash=\(Urls.apiHash)")
        return url
    }

    func getComicsUrl(id: Int) -> URL? {

        let url = URL(string: "https://gateway.marvel.com/v1/public/characters/\(id)/comics?limit=3&ts=\(Urls.apiTime)&apikey=\(Urls.apiPublicKey)&hash=\(Urls.apiHash)")
        return url
    }

    func getEventsUrl(id: Int) -> URL? {

        let url = URL(string: "https://gateway.marvel.com/v1/public/characters/\(id)/events?limit=3&ts=\(Urls.apiTime)&apikey=\(Urls.apiPublicKey)&hash=\(Urls.apiHash)")
        return url
    }

    func getSeriesUrl(id: Int) -> URL? {

        let url = URL(string: "https://gateway.marvel.com/v1/public/characters/\(id)/series?limit=3&ts=\(Urls.apiTime)&apikey=\(Urls.apiPublicKey)&hash=\(Urls.apiHash)")
        return url
    }

    func getStories(id: Int) -> URL? {

        let url = URL(string: "https://gateway.marvel.com/v1/public/characters/\(id)/stories?limit=3&ts=\(Urls.apiTime)&apikey=\(Urls.apiPublicKey)&hash=\(Urls.apiHash)")
        return url
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
