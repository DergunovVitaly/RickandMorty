//
//  Character.swift
//  RickAndMorty
//
//  Created by Vitaliy on 06.02.2025.
//
import Foundation

struct CharactersResponse: Codable {
    let info: Info
    let results: [Character]
}
