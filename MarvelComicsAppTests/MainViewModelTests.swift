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

    var favouritesId: FavouritesSet!

    var data: [CharacterThumbnail]!

    var searchData: [CharacterThumbnail]!

    var text: String!

    var searchState: Bool!

    var doneLoaded: Bool!

    var doneLoadedSearch: Bool!

    var task: Task<(), Never>!

    var viewModel: MainViewModel!

    override func setUpWithError() throws {

        try super.setUpWithError()
        self.service = MockedMainWebservice()
        self.searchData = [CharacterThumbnail(id: 10, name: "Insonias", image: UIImage(), favourite: true), CharacterThumbnail(id: 11, name: "Intacto", image: UIImage(), favourite: false), CharacterThumbnail(id: 12, name: "Interno", image: UIImage(), favourite: false)]
        self.data = [CharacterThumbnail(id: 1, name: "Bruno Aleixo", image: UIImage(), favourite: true), CharacterThumbnail(id: 2, name: "Bussaco", image: UIImage(), favourite: false), CharacterThumbnail(id: 3, name: "Renato", image: UIImage(), favourite: false)]
        FavouritesSet.sharedInstance.setFavourites(favourites: [1, 10, 11])
        self.favouritesId = FavouritesSet.sharedInstance
        self.text = "In"
        self.searchState = true
        self.doneLoaded = true
        self.doneLoadedSearch = true
        self.task = nil
        self.viewModel = MainViewModel(webservice: self.service, favouriteIds: self.favouritesId, characterThumbnails: self.data, characterThumbnailsSearch: self.searchData, text: self.text, searchState: self.searchState, doneLoaded: self.doneLoaded, doneLoadedSearch: self.doneLoadedSearch, task: self.task)
    }

    override func tearDownWithError() throws {

        self.service = nil
        self.searchData = nil
        self.data = nil
        self.favouritesId = nil
        self.text = nil
        self.searchState = nil
        self.doneLoaded = nil
        self.doneLoadedSearch = nil
        self.task = nil
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

        let expectedId = viewModel.characterThumbnailsSearch[indexPath.row].id
        let expectedName = viewModel.characterThumbnailsSearch[indexPath.row].name
        let expectedImage = viewModel.characterThumbnailsSearch[indexPath.row].image
        let expectedFavourite = viewModel.characterThumbnailsSearch[indexPath.row].favourite

        let result = viewModel.characterForRowAt(indexPath: indexPath)

        XCTAssertEqual(expectedId, result.0)
        XCTAssertEqual(expectedName, result.1)
        XCTAssertEqual(expectedImage, result.2)
        XCTAssertEqual(expectedFavourite, result.3)
    }

    func testChangeFavourite() {

        let id = 12

        let expectedFavourite = true

        viewModel.changeFavourite(id: id)

        let result = viewModel.characterThumbnailsSearch[2].favourite

        XCTAssertEqual(expectedFavourite, result)
    }

    func testChangeFavouriteForData() {

        let id = 3

        let expectedFavourite = true

        viewModel.changeFavouriteForArray(id: id, array: self.data)

        let result = data[2].favourite

        XCTAssertEqual(expectedFavourite, result)
    }

    func testChangeFavouriteForSearchData() {

        let id = 12

        let expectedFavourite = true

        viewModel.changeFavouriteForArray(id: id, array: self.searchData)

        let result = searchData[2].favourite

        XCTAssertEqual(expectedFavourite, result)
    }

    func testDataLoadOnFetchSuccess() async throws {

        self.viewModel.changeState()

        let characterDataWrapper = CharactersDataWrapper(data: CharactersDataContainer(
            results: [Character(id: 5, name: "Capitão Falcão", thumbnail: Image(path: "123", extension0: ".jpg"))]))
        self.service.fetchCharactersInfoMockResult = characterDataWrapper

        var imageData = Data()
        if let url = URL(string: "http://i.annihil.us/u/prod/marvel/i/mg/8/a0/523ca6f2b11e4.jpg") {

            (imageData, _) = try await URLSession.shared.data(from: url)
        }
        self.service.fetchCharactersImageData = imageData
        await viewModel.dataLoad()

        XCTAssertEqual(viewModel.characterThumbnails.count, 4)
        XCTAssertEqual(viewModel.characterThumbnails[3].id, 5)
        XCTAssertEqual(viewModel.characterThumbnails[3].name, "Capitão Falcão")
        XCTAssertEqual(viewModel.characterThumbnails[3].image.pngData(), UIImage(data: imageData)?.pngData())
        XCTAssertEqual(viewModel.characterThumbnails[3].favourite, false)
    }

    func testDataLoadOnFetchFailure() async throws {

        self.viewModel.changeState()

        self.service.fetchCharactersInfoMockResult = nil

        self.service.fetchCharactersImageData = nil
        await viewModel.dataLoad()

        XCTAssertEqual(viewModel.characterThumbnails.count, 3)
    }

    func testDataLoadSearchOnFetchSuccess() async throws {

        //self.viewModel.changeState()

        let characterDataWrapper = CharactersDataWrapper(data: CharactersDataContainer(
            results: [Character(id: 5, name: "Capitão Falcão", thumbnail: Image(path: "123", extension0: ".jpg"))]))
        self.service.fetchCharactersInfoSearchMockResult = characterDataWrapper

        var imageData = Data()
        if let url = URL(string: "http://i.annihil.us/u/prod/marvel/i/mg/8/a0/523ca6f2b11e4.jpg") {

            (imageData, _) = try await URLSession.shared.data(from: url)
        }
        self.service.fetchCharactersImageData = imageData
        await viewModel.dataLoadSearch()

        XCTAssertEqual(viewModel.characterThumbnailsSearch.count, 4)
        XCTAssertEqual(viewModel.characterThumbnailsSearch[3].id, 5)
        XCTAssertEqual(viewModel.characterThumbnailsSearch[3].name, "Capitão Falcão")
        XCTAssertEqual(viewModel.characterThumbnailsSearch[3].image.pngData(), UIImage(data: imageData)?.pngData())
        XCTAssertEqual(viewModel.characterThumbnailsSearch[3].favourite, false)
    }

    func testDataLoadSearchOnFetchFailure() async throws {

        //self.viewModel.changeState()

        self.service.fetchCharactersInfoSearchMockResult = nil

        self.service.fetchCharactersImageData = nil
        await viewModel.dataLoadSearch()

        XCTAssertEqual(viewModel.characterThumbnailsSearch.count, 3)
    }

    func testFilterFavourites() {

        let expected: [CharacterThumbnail] = [CharacterThumbnail(id: 1, name: "Bruno Aleixo", image: UIImage(), favourite: true), CharacterThumbnail(id: 10, name: "Insonias", image: UIImage(), favourite: true)]

        let result = viewModel.filterFavourites()

        XCTAssertEqual(expected.count, result.count)
        XCTAssertEqual(expected[0].id, result[0].id)
        XCTAssertEqual(expected[0].name, result[0].name)
        XCTAssertEqual(expected[0].image, result[0].image)
        XCTAssertEqual(expected[0].favourite, result[0].favourite)
        XCTAssertEqual(expected[1].id, result[1].id)
        XCTAssertEqual(expected[1].name, result[1].name)
        XCTAssertEqual(expected[1].image, result[1].image)
        XCTAssertEqual(expected[1].favourite, result[1].favourite)
    }

    func testFilterFavouritesFromArray() {

        let expected: [CharacterThumbnail] = [CharacterThumbnail(id: 1, name: "Bruno Aleixo", image: UIImage(), favourite: true)]

        let array = [CharacterThumbnail(id: 1, name: "Bruno Aleixo", image: UIImage(), favourite: true), CharacterThumbnail(id: 10, name: "Insonias", image: UIImage(), favourite: false)]
        let result = viewModel.filterFavouritesFromArray(array: array)

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

        let expectedIdList: Set<Int> = [1, 10, 11]
        let expectedCharacterFavourite = true

        viewModel.setAllFavourites()

        XCTAssertEqual(expectedIdList, viewModel.getFavourites())
        XCTAssertEqual(expectedCharacterFavourite, viewModel.characterThumbnailsSearch[1].favourite)
    }

    /*
    func testChangeFavouriteCaseAppend() {

        let id = 4
        let favourite = true

        let expectedId = viewModel.characterThumbnails[0].id
        let expectedName = viewModel.characterThumbnails[0].name
        let expectedImage = viewModel.characterThumbnails[0].image
        let expectedFavourite = viewModel.characterThumbnails[0].favourite

        viewModel.changeFavourite(id: id)

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

        viewModel.changeFavourite(id: id)

        XCTAssertEqual(3, viewModel.characterThumbnails.count)
        XCTAssertEqual(expectedId,viewModel.characterThumbnails[1].id)
        XCTAssertEqual(expectedName, viewModel.characterThumbnails[1].name)
        XCTAssertEqual(expectedImage, viewModel.characterThumbnails[1].image)
        XCTAssertEqual(expectedFavourite, viewModel.characterThumbnails[1].favourite)
    }
     */

    func testGetFavourites() {

        let expected: Set<Int> = [1, 10, 11]

        let result = viewModel.getFavourites()

        XCTAssertEqual(expected, result)
    }

    func testChangeState() {

        let expected = false

        viewModel.changeState()

        XCTAssertEqual(expected, viewModel.getState())
    }

    func testGetState() {

        let expected = true

        XCTAssertEqual(expected, viewModel.getState())
    }

    func testGetText() {

        let expected = "In"

        let result = viewModel.getText()

        XCTAssertEqual(expected, result)
    }

    func testSetText() {

        let expected = "Bruno"

        let text = "Bruno"

        viewModel.setText(text: text)

        XCTAssertEqual(expected, viewModel.getText())
    }

    func testResetCharacterThumbnailsSearch() {

        let expected: [CharacterThumbnail] = []

        viewModel.resetCharacterThumbnailsSearch()

        XCTAssertEqual(expected.count, viewModel.characterThumbnailsSearch.count)
    }

    func testGetDoneLoaded() {

        let expected = true

        let result = viewModel.getDoneLoaded()

        XCTAssertEqual(expected, result)
    }

    func testGetDoneLoadedSearch() {

        let expected = true

        let result = viewModel.getDoneLoadedSearch()

        XCTAssertEqual(expected, result)
    }

    func testSetDoneLoaded() {

        let expected = false

        viewModel.setDoneLoaded(doneLoaded: false)

        let result = viewModel.getDoneLoaded()

        XCTAssertEqual(expected, result)
    }

    func testSetDoneLoadedSearch() {

        let expected = false

        viewModel.setDoneLoadedSearch(doneLoadedSearch: false)

        let result = viewModel.getDoneLoadedSearch()

        XCTAssertEqual(expected, result)
    }

}
