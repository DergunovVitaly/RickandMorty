//
//  CharacterListViewModelTests.swift
//  RickAndMortyTests
//
//  Created by Vitaliy on 07.02.2025.
//

import Foundation
import XCTest
@testable import RickAndMorty

final class MockNetworkService: NetworkService {
    
    var shouldThrowError = false
    var mockResponse: CharactersResponse?
    
    func fetchCharacters(page: Int, status: String?) async throws -> CharactersResponse {
        if shouldThrowError {
            throw NSError(domain: "MockError", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "Test Error"])
        }
        guard let response = mockResponse else {
            throw NSError(domain: "MockError", code: -2,
                          userInfo: [NSLocalizedDescriptionKey: "No mockResponse set"])
        }
        return response
    }
}

struct TestData {
    static let sampleCharactersResponse: CharactersResponse = {
        let info = Info(count: 40, pages: 2, next: nil, prev: nil)
        
        let exampleCharacter = Character(
            id: 1,
            name: "Rick",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            origin: Location(name: "Earth", url: ""),
            location: Location(name: "Citadel of Ricks", url: ""),
            image: "https://example.com/rick.png",
            episode: [],
            url: "",
            created: ""
        )
        
        return CharactersResponse(info: info, results: [exampleCharacter])
    }()
}

@MainActor
final class CharacterListViewModelTests: XCTestCase {
    
    private var viewModel: CharacterListViewModel!
    private var mockService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockService = MockNetworkService()
        viewModel = CharacterListViewModel(networkService: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    func testFetchCharactersSuccess() async {
        // Given
        mockService.shouldThrowError = false
        mockService.mockResponse = TestData.sampleCharactersResponse
        
        // When
        await viewModel.fetchCharacters()
        
        // Then
        XCTAssertEqual(viewModel.characters.count, 1,
                       "1 character should load")
        XCTAssertEqual(viewModel.characters.first?.name, "Rick")
        
        XCTAssertNil(viewModel.errorMessage,
                     "There should be no error on successful download.")
    
    }
    
    func testFetchCharactersError() async {
        // Given
        mockService.shouldThrowError = true
        
        // When
        await viewModel.fetchCharacters()
        
        // Then
        XCTAssertTrue(viewModel.characters.isEmpty,
                      "The characters array should remain empty.")
        XCTAssertNotNil(viewModel.errorMessage,
                        "errorMessage must be filled in on error")
    }
    
    func testRefreshClearsData() async {
      
        mockService.shouldThrowError = false
        mockService.mockResponse = TestData.sampleCharactersResponse
        
        await viewModel.fetchCharacters()
        XCTAssertFalse(viewModel.characters.isEmpty,
                       "After fetchCharacters the array must not be empty")
        
       
        await viewModel.refresh()
        XCTAssertFalse(viewModel.characters.isEmpty,
                       "After refresh() the array should be filled again")
    }
}
