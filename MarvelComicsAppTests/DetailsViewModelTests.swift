//
//  DetailsViewModelTests.swift
//  MarvelComicsAppTests
//
//  Created by Pedro Lemos Silva on 13/11/2023.
//

import XCTest
@testable import MarvelComicsApp

final class DetailsViewModelTests: XCTestCase {

    var service: MockedDetailsWebservice!

    var characterThumbnail: CharacterThumbnail!

    var characterDetails: [String: [Detail]]!

    var viewModel: DetailsViewModel!

    override func setUpWithError() throws {

        try super.setUpWithError()
        self.service = MockedDetailsWebservice()
        self.characterThumbnail = CharacterThumbnail(id: 1, name: "Capitão Falcão" , image: UIImage(), favourite: false)
        self.characterDetails = ["Ano": [Detail(title: "123", description: "abc")], "Literatura": [Detail(title: "Livro", description: "Letras")]]
        self.viewModel = DetailsViewModel(webservice: service, characterDetails: characterDetails, characterThumbnail: characterThumbnail)
    }

    override func tearDownWithError() throws {

        self.service = nil
        self.characterDetails = nil
        self.characterThumbnail = nil
        self.viewModel = nil
        try super.tearDownWithError()
    }

    func testDataFormattingOnFetchSuccess() async {

        let comicsDataWrapper = DetailsDataWrapper(data: DetailsDataContainer(results: [Detail(title: "comic1", description: "comic_d1"), Detail(title: "comic2", description: "comic_d2")]))
        let eventsDataWrapper = DetailsDataWrapper(data: DetailsDataContainer(results: [Detail(title: "event1", description: "event_d1"), Detail(title: "event2", description: "event_d2")]))
        let seriesDataWrapper = DetailsDataWrapper(data: DetailsDataContainer(results: [Detail(title: "serie1", description: "serie_d1"), Detail(title: "serie2", description: "serie_d2")]))
        let storiesDataWrapper = DetailsDataWrapper(data: DetailsDataContainer(results: [Detail(title: "storie1", description: "storie_d1"), Detail(title: "storie2", description: "storie_d2")]))

        self.service.fetchComicsMockResults = comicsDataWrapper
        self.service.fetchEventsMockResults = eventsDataWrapper
        self.service.fetchSeriesMockResults = seriesDataWrapper
        self.service.fetchStoriesMockResults = storiesDataWrapper

        await self.viewModel.dataFormatting()

        XCTAssertEqual(viewModel.characterDetails.count, 7)
        XCTAssertEqual(viewModel.characterDetails["Character"]?[0].title, "")
        XCTAssertEqual(viewModel.characterDetails["Comics"]?[0].title, "comic1")
        XCTAssertEqual(viewModel.characterDetails["Comics"]?[1].title, "comic2")
        XCTAssertEqual(viewModel.characterDetails["Events"]?[0].title, "event1")
        XCTAssertEqual(viewModel.characterDetails["Events"]?[1].title, "event2")
        XCTAssertEqual(viewModel.characterDetails["Series"]?[0].title, "serie1")
        XCTAssertEqual(viewModel.characterDetails["Series"]?[1].title, "serie2")
        XCTAssertEqual(viewModel.characterDetails["Stories"]?[0].title, "storie1")
        XCTAssertEqual(viewModel.characterDetails["Stories"]?[1].title, "storie2")

    }

    func testGetCharacterThumbnail() {

        let id =  viewModel.getCharacterThumbnail().0
        let name = viewModel.getCharacterThumbnail().1
        let image = viewModel.getCharacterThumbnail().2

        XCTAssertEqual(id, 1)
        XCTAssertEqual(name, "Capitão Falcão")
        XCTAssertEqual(image.pngData(), UIImage().pngData())
    }

    func testSetCharacterThumbnail() {

        let expected = (id: 100, name: "Blank", image: UIImage(), favourite: true)

        viewModel.setCharacterThumbnail(id: 100, name: "Blank", image: UIImage(), favourite: true)

        XCTAssertEqual(viewModel.getCharacterThumbnail().0, expected.id)
        XCTAssertEqual(viewModel.getCharacterThumbnail().1, expected.name)
        XCTAssertEqual(viewModel.getCharacterThumbnail().2, expected.image)
    }

    func testGetCharacterDetailsKeys() {

        let expected = ["Ano", "Literatura"]

        let result = viewModel.getCharacterDetailsKeys()

        XCTAssertEqual(expected, result)
    }

    func testCharacterForRowAtSectionAt() {

        let expectedTitle = "123"
        let expectedDescription = "abc"

        let indexPath = IndexPath(row: 0, section: 0)
        let key = "Ano"

        let results = viewModel.characterForRowAtSectionAt(indexPath: indexPath, key: key)

        XCTAssertEqual(expectedTitle, results.0)
        XCTAssertEqual(expectedDescription, results.1)
    }

    func testNumberOfSections() {

        let expected = 2

        let result = viewModel.numberOfSections()

        XCTAssertEqual(result, expected)
    }

    func testNumberOfRowsInSection() {

        let expected = 1

        let section = "Ano"

        let result = viewModel.numberOfRowsInSection(section: section)

        XCTAssertEqual(result, expected)
    }
}
