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

        let ctct = CharacterThumbnailCell()

        assertSnapshot(of: ctct, as: .image)
    }
}
