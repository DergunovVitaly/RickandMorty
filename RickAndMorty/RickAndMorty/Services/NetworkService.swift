//
//  NetworkService.swift
//  RickAndMorty
//
//  Created by Vitaliy on 06.02.2025.
//

import Foundation

protocol NetworkService {
    func fetchCharacters(page: Int, status: String?) async throws -> CharactersResponse
}

class RickAndMortyNetworkService: NetworkService {
    private let baseURL = URL(string: "https://rickandmortyapi.com/api/character")!

    func fetchCharacters(page: Int, status: String?) async throws -> CharactersResponse {
       
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!
        var queryItems = [URLQueryItem(name: "page", value: "\(page)")]
        if let status = status, !status.isEmpty {
            queryItems.append(URLQueryItem(name: "status", value: status))
        }
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw NSError(domain: "InvalidURL", code: 0, userInfo: nil)
        }
     
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedResponse = try JSONDecoder().decode(CharactersResponse.self, from: data)
        return decodedResponse
    }
}
