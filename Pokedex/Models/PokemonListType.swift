//
//  PokemonListType.swift
//  Pokedex
//
//  Created by David Quispe Aruquipa on 05/02/24.
//

import Foundation

enum PokemonListType: String, CaseIterable, Identifiable {
    var id: Int {
        switch self {
        case .all: return 0
        case .favorites: return 1
        }
    }
    
    case all
    case favorites
    
    var systemImage: String {
        switch self {
        case .all: return "list.bullet"
        case .favorites: return "star"
        }
    }
}
