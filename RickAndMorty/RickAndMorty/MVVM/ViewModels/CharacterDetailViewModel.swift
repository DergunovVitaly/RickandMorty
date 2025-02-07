//
//  CharacterDetailViewModel.swift
//  RickAndMorty
//
//  Created by Vitaliy on 07.02.2025.
//
import Foundation

class CharacterDetailViewModel: ObservableObject {
    
    let character: Character
   
    init(character: Character) {
        self.character = character
    }
}
