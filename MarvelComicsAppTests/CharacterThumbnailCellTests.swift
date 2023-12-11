//
//  CharacterThumbnailCellTests.swift
//  MarvelComicsAppTests
//
//  Created by Pedro Lemos Silva on 14/11/2023.
//
import SnapshotTesting
import XCTest
@testable import MarvelComicsApp

final class CharacterThumbnailCellTest: XCTestCase {

    func testCharacterThumbnailCell() {

        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 100)

        let view = CharacterThumbnailCell(frame: frame)

        let image = UIImage()
        view.transferThumbnailData(id: 1, name: "Capitão Falcão", thumbnailImage: UIImage(), favourite: true)

        assertSnapshot(of: view, as: .image)
    }
}
