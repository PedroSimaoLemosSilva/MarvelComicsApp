//
//  DetailsWebserviceProtocol.swift
//  MarvelComicsApp
//
//  Created by Pedro Lemos Silva on 13/11/2023.
//

import Foundation
import UIKit

protocol DetailsWebserviceProtocol {

    func dataFormatting()

    func getCharacterThumbnail() -> (Int, String, UIImage)
}
