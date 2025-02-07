//
//  CharacterListViewModel.swift
//  RickAndMorty
//
//  Created by Vitaliy on 06.02.2025.
//
import Foundation
import Combine

@MainActor
class CharacterListViewModel: ObservableObject {
  
    @Published var characters: [Character] = []
    @Published var errorMessage: String?
    
    private let networkService: NetworkService
    private var currentPage: Int = 1
    private var totalPages: Int = 1
    
    var statusFilter: String?
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchCharacters(reset: Bool = false) async {
        if reset {
            currentPage = 1
            totalPages = 1
            characters.removeAll()
        }
        
        guard currentPage <= totalPages else { return }
        
        do {
            let response = try await networkService.fetchCharacters(page: currentPage, status: statusFilter)
            characters.append(contentsOf: response.results)
            totalPages = response.info.pages
            currentPage += 1
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func refresh() async {
        await fetchCharacters(reset: true)
    }
}
