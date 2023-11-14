//
//  MainViewModelTests.swift
//  MarvelComicsAppTests
//
//  Created by Pedro Lemos Silva on 13/11/2023.
//

import XCTest
@testable import MarvelComicsApp

final class MainViewModelTests: XCTestCase {

    var service: MockedMainWebservice = MockedMainWebservice()

    var data: [CharacterThumbnail] = []

    var viewModel: MainViewModel = MainViewModel()

    override func setUp() {

        super.setUp()
        self.service = MockedMainWebservice()
        self.data = [CharacterThumbnail(),CharacterThumbnail(),CharacterThumbnail()]
        self.viewModel = MainViewModel(webservice: service, characterThumbnails: data)
    }

    override func tearDown() {

        self.service = MockedMainWebservice()
        self.data = []
        self.viewModel = MainViewModel()
        super.tearDown()
    }

    func testNumberOfRows() {

        let expected = 3

        let value = viewModel.numberOfRows()

        XCTAssertEqual(value, expected)
    }

    func testDataLoadOnFetchSuccess() {

        Task {

            let characterDataWrapper = CharactersDataWrapper(data: CharactersDataContainer(
                results: [Character(id: 1, name: "Capitão Falcão", thumbnail: Image(path: "123", extension0: ".jpg"))]))
            self.service.fetchCharactersInfoMockResult = characterDataWrapper

            let imageData = Data()
            self.service.fetchCharactersImageData = imageData

            await viewModel.dataLoad()

            XCTAssertEqual(viewModel.characterThumbnails.count, 1)
            XCTAssertEqual(viewModel.characterThumbnails[0].id, 1)
            XCTAssertEqual(viewModel.characterThumbnails[0].name, "Capitão Falcão")
            XCTAssertEqual(viewModel.characterThumbnails[0].image, UIImage(data: Data()))
        }
    }



}
