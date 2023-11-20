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

    var favouritesId: [Int]!

    var viewModel: MainViewModel!

    override func setUpWithError() throws {

        try super.setUpWithError()
        self.service = MockedMainWebservice()
        self.data = [CharacterThumbnail(id: 1, name: "Bruno Aleixo", image: UIImage(), favourite: true), CharacterThumbnail(id: 2, name: "Bussaco", image: UIImage(), favourite: false), CharacterThumbnail(id: 3, name: "Renato", image: UIImage(), favourite: false)]
        self.favouritesId = [3]
        self.viewModel = MainViewModel(webservice: self.service, characterThumbnails: self.data, favouriteId: self.favouritesId)
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

    func testChangeFavouriteCaseAppend() {

        let id = 4
        let favourite = true

        let expectedId = viewModel.characterThumbnails[0].id
        let expectedName = viewModel.characterThumbnails[0].name
        let expectedImage = viewModel.characterThumbnails[0].image
        let expectedFavourite = viewModel.characterThumbnails[0].favourite

        viewModel.changeFavourite(id: id, favourite: favourite)

        XCTAssertEqual(3, viewModel.characterThumbnails.count)
        XCTAssertEqual(expectedId,viewModel.characterThumbnails[0].id)
        XCTAssertEqual(expectedName, viewModel.characterThumbnails[0].name)
        XCTAssertEqual(expectedImage, viewModel.characterThumbnails[0].image)
        XCTAssertEqual(expectedFavourite, viewModel.characterThumbnails[0].favourite)

    }

    func testChangeFavouriteCaseRemove() {

        let id = 2
        let favourite = false

        let expectedId = viewModel.characterThumbnails[1].id
        let expectedName = viewModel.characterThumbnails[1].name
        let expectedImage = viewModel.characterThumbnails[1].image
        let expectedFavourite = false

        viewModel.changeFavourite(id: id, favourite: favourite)

        XCTAssertEqual(3, viewModel.characterThumbnails.count)
        XCTAssertEqual(expectedId,viewModel.characterThumbnails[1].id)
        XCTAssertEqual(expectedName, viewModel.characterThumbnails[1].name)
        XCTAssertEqual(expectedImage, viewModel.characterThumbnails[1].image)
        XCTAssertEqual(expectedFavourite, viewModel.characterThumbnails[1].favourite)
    }

    func testFilterFavourites() {

        let expected: [CharacterThumbnail] = [CharacterThumbnail(id: 1, name: "Bruno Aleixo", image: UIImage(), favourite: true)]

        let result = viewModel.filterFavourites()

        XCTAssertEqual(expected.count, result.count)
        XCTAssertEqual(expected[0].id, result[0].id)
        XCTAssertEqual(expected[0].name, result[0].name)
        XCTAssertEqual(expected[0].image, result[0].image)
        XCTAssertEqual(expected[0].favourite, result[0].favourite)
    }
    /*
    func testLoadAllFavourites() {

        viewModel.favouritesId = [1,2,3]

        let expected = true

        viewModel.loadAllFavourites()

        XCTAssertEqual(expected, viewModel.characterThumbnails[1].favourite)

    }
     */
    func testSetAllFavourites() {

        let expectedIdList = [3]
        let expectedCharacterFavourite = true

        viewModel.setAllFavourites()

        XCTAssertEqual(expectedIdList, viewModel.favouritesId)
        XCTAssertEqual(expectedCharacterFavourite, viewModel.characterThumbnails[2].favourite)
    }
}
