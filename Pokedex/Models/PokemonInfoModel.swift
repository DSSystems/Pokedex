//
//  PokemonInfoModel.swift
//  Pokedex
//
//  Created by David Quispe Aruquipa on 06/02/24.
//

import Foundation

struct PokemonInfoModel {
    struct Stat {
        let name: String
        let value: Int
    }
    
    struct Ability {
        let name: String
        let isHidden: Bool
    }
        
    let id: Int
    let name: String
    let frontImageUrl: URL
    let backImageUrl: URL
    let stats: [Stat]
    let types: [String]
    let abilities: [Ability]
}
