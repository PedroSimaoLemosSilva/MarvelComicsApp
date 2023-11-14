//
//  MainViewModelTests.swift
//  MarvelComicsAppTests
//
//  Created by Pedro Lemos Silva on 13/11/2023.
//

import XCTest
@testable import MarvelComicsApp

final class MainViewModelTests: XCTestCase {

    var service: MockedMainWebservice!

    var data: [CharacterThumbnail]!

    var viewModel: MainViewModel!

    override func setUpWithError() throws {

        try super.setUpWithError()
        self.service = MockedMainWebservice()
        self.data = [CharacterThumbnail(), CharacterThumbnail(), CharacterThumbnail()]
        self.viewModel = MainViewModel(webservice: service, characterThumbnails: data)
    }

    override func tearDownWithError() throws {

        self.service = nil
        self.data = nil
        self.viewModel = nil
        try super.tearDownWithError()
    }

    func testNumberOfRows() {

        let expected = 3

        let value = viewModel.numberOfRows()

        XCTAssertEqual(value, expected)
    }

    func testCharacterForRowAt() {

        let indexPath = IndexPath(row: 1, section: 0)

        let expectedId = viewModel.characterThumbnails[indexPath.row].id
        let expectedName = viewModel.characterThumbnails[indexPath.row].name
        let expectedImage = viewModel.characterThumbnails[indexPath.row].image

        guard let result = viewModel.characterForRowAt(indexPath: indexPath) else {

            return
        }

        XCTAssertEqual(expectedId, result.0)
        XCTAssertEqual(expectedName, result.1)
        XCTAssertEqual(expectedImage, result.2)
    }

    func testDataLoadOnFetchSuccess() async throws {

        let characterDataWrapper = CharactersDataWrapper(data: CharactersDataContainer(
            results: [Character(id: 1, name: "Capitão Falcão", thumbnail: Image(path: "123", extension0: ".jpg"))]))
        self.service.fetchCharactersInfoMockResult = characterDataWrapper

        var imageData = Data()
        if let url = URL(string: "http://i.annihil.us/u/prod/marvel/i/mg/8/a0/523ca6f2b11e4.jpg") {

            (imageData, _) = try await URLSession.shared.data(from: url)
        }
        self.service.fetchCharactersImageData = imageData
        await viewModel.dataLoad()

        XCTAssertEqual(viewModel.characterThumbnails.count, 4)
        XCTAssertEqual(viewModel.characterThumbnails[3].id, 1)
        XCTAssertEqual(viewModel.characterThumbnails[3].name, "Capitão Falcão")
        XCTAssertEqual(viewModel.characterThumbnails[3].image.pngData(), UIImage(data: imageData)?.pngData())
    }

    func testDataLoadOnFetchFailure() async throws {

        self.service.fetchCharactersInfoMockResult = nil

        self.service.fetchCharactersImageData = nil
        await viewModel.dataLoad()

        XCTAssertEqual(viewModel.characterThumbnails.count, 3)
    }

}
