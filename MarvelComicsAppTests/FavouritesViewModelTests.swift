//
//  FavouritesViewModelTests.swift
//  MarvelComicsAppTests
//
//  Created by Pedro Lemos Silva on 20/11/2023.
//

import XCTest
@testable import MarvelComicsApp

final class FavouritesViewModelTests: XCTestCase {

    var service: MockedFavouritesWebservice!

    var viewModel: FavouritesViewModel!

    var characterThumbnails: [CharacterThumbnail]!

    var characterThumbnailsDeleted: [CharacterThumbnail]!

    var favouritesId: Set<Int>!

    var favouritesIdNotLoaded: Set<Int>!

    override func setUpWithError() throws {

        try super.setUpWithError()
        self.service = MockedFavouritesWebservice()
        self.characterThumbnails = [CharacterThumbnail(id: 1, name: "Bruno Aleixo", image: UIImage(), favourite: true),CharacterThumbnail(id: 2, name: "Bussaco", image: UIImage(), favourite: true)]
        self.characterThumbnailsDeleted = [CharacterThumbnail(id: 4, name: "Renato", image: UIImage(), favourite: false)]
        self.favouritesId = [1, 2]
        self.favouritesIdNotLoaded = [3]
        self.viewModel = FavouritesViewModel(webservice: service, characterThumbnails: characterThumbnails,
                                             characterThumbnailsDeleted: characterThumbnailsDeleted, favouriteIds: favouritesId,favouritesIdNotLoaded: favouritesIdNotLoaded)
    }

    override func tearDownWithError() throws {

        self.service = nil
        self.characterThumbnails = nil
        self.characterThumbnailsDeleted = nil
        self.favouritesId = nil
        self.favouritesIdNotLoaded = nil
        self.viewModel = nil
        try super.tearDownWithError()
    }

    func testNumberOfRows() {

        let expected = 2

        let value = viewModel.numberOfRows()

        XCTAssertEqual(value, expected)
    }

    func testCharacterForRowAt() {

        let indexPath = IndexPath(row: 1, section: 0)

        let expectedId = viewModel.characterThumbnails[indexPath.row].id
        let expectedName = viewModel.characterThumbnails[indexPath.row].name
        let expectedImage = viewModel.characterThumbnails[indexPath.row].image
        let expectedFavourite = viewModel.characterThumbnails[indexPath.row].favourite

        guard let result = viewModel.characterForRowAt(indexPath: indexPath) else {

            return
        }

        XCTAssertEqual(expectedId, result.0)
        XCTAssertEqual(expectedName, result.1)
        XCTAssertEqual(expectedImage, result.2)
        XCTAssertEqual(expectedFavourite, result.3)
    }

    func testCharacterForRowAtImage() {

        let indexPath = IndexPath(row: 1, section: 0)

        let expectedId = viewModel.characterThumbnails[indexPath.row].id
        let expectedName = viewModel.characterThumbnails[indexPath.row].name
        let expectedImage = viewModel.characterThumbnails[indexPath.row].image
        let expectedFavourite = viewModel.characterThumbnails[indexPath.row].favourite

        let result = viewModel.characterForRowAtImage(indexPath: indexPath)

        XCTAssertEqual(expectedId, result.0)
        XCTAssertEqual(expectedName, result.1)
        XCTAssertEqual(expectedImage, result.2)
        XCTAssertEqual(expectedFavourite, result.3)
    }

    func testChangeFavouriteCaseAppend() {

        let id = 4
        let favourite = true

        let expectedId = viewModel.characterThumbnailsDeleted[0].id
        let expectedName = viewModel.characterThumbnailsDeleted[0].name
        let expectedImage = viewModel.characterThumbnailsDeleted[0].image
        let expectedFavourite = true

        viewModel.changeFavourite(id: id)

        XCTAssertEqual(3, viewModel.characterThumbnails.count)
        XCTAssertEqual(0, viewModel.characterThumbnailsDeleted.count)
        XCTAssertEqual(3, viewModel.favouriteIds.countFavourite())
        XCTAssertEqual(1, viewModel.favouritesIdNotLoaded.count)
        XCTAssertEqual(expectedId,viewModel.characterThumbnails[2].id)
        XCTAssertEqual(expectedName, viewModel.characterThumbnails[2].name)
        XCTAssertEqual(expectedImage, viewModel.characterThumbnails[2].image)
        XCTAssertEqual(expectedFavourite, viewModel.characterThumbnails[2].favourite)

    }

    func testChangeFavouriteCaseRemove() {

        let id = 2
        let favourite = false

        let expectedId = viewModel.characterThumbnails[1].id
        let expectedName = viewModel.characterThumbnails[1].name
        let expectedImage = viewModel.characterThumbnails[1].image
        let expectedFavourite = false

        viewModel.changeFavourite(id: id)

        XCTAssertEqual(1, viewModel.characterThumbnails.count)
        XCTAssertEqual(2, viewModel.characterThumbnailsDeleted.count)
        XCTAssertEqual(1, viewModel.favouriteIds.countFavourite())
        XCTAssertEqual(1, viewModel.favouritesIdNotLoaded.count)
        XCTAssertEqual(expectedId,viewModel.characterThumbnailsDeleted[1].id)
        XCTAssertEqual(expectedName, viewModel.characterThumbnailsDeleted[1].name)
        XCTAssertEqual(expectedImage, viewModel.characterThumbnailsDeleted[1].image)
        XCTAssertEqual(expectedFavourite, viewModel.characterThumbnailsDeleted[1].favourite)
    }

    func testSetCharacterThumbnails() {

        let characterThumbnails = [CharacterThumbnail(),CharacterThumbnail()]

        let expectedCount = 2
        viewModel.setCharacterThumbnails(characterThumbnails: characterThumbnails)

        XCTAssertEqual(expectedCount, viewModel.characterThumbnails.count)
    }

    func testCheckFavouriteInList() {

        let expectedCount = 1
        let expectedNotLoadedId = 3

        viewModel.checkFavouriteInList()

        XCTAssertEqual(expectedCount, viewModel.favouritesIdNotLoaded.count)
        XCTAssertEqual(expectedNotLoadedId, viewModel.favouritesIdNotLoaded.first)
    }

    func testDataLoadOnFetchSuccess() async throws {

        let characterDataWrapper = CharactersDataWrapper(data: CharactersDataContainer(
            results: [Character(id: 3, name: "Capitão Falcão", thumbnail: Image(path: "123", extension0: ".jpg"))]))
        self.service.fetchCharactersMockResult = characterDataWrapper

        var imageData = Data()
        if let url = URL(string: "http://i.annihil.us/u/prod/marvel/i/mg/8/a0/523ca6f2b11e4.jpg") {

            (imageData, _) = try await URLSession.shared.data(from: url)
        }
        self.service.fetchCharactersImageData = imageData
        await viewModel.dataLoad()

        XCTAssertEqual(viewModel.characterThumbnails.count, 3)
        XCTAssertEqual(viewModel.characterThumbnails[2].id, 3)
        XCTAssertEqual(viewModel.characterThumbnails[2].name, "Capitão Falcão")
        XCTAssertEqual(viewModel.characterThumbnails[2].image.pngData(), UIImage(data: imageData)?.pngData())
    }

    func testDataLoadOnFetchFailure() async throws {

        self.service.fetchCharactersMockResult = nil

        self.service.fetchCharactersImageData = nil
        await viewModel.dataLoad()

        XCTAssertEqual(viewModel.characterThumbnails.count, 2)
    }
}
