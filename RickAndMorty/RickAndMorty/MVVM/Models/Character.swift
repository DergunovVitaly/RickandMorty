//
//  Character.swift
//  RickAndMorty
//
//  Created by Vitaliy on 07.02.2025.
//



struct Character: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let origin: Location
    let location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

struct Location: Codable {
    let name: String
    let url: String
    
    var isEmpty: Bool {
        name.isEmpty
    }
}
