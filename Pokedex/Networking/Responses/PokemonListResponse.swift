//
//  PokemonListResponse.swift
//  Pokedex
//
//  Created by David Quispe Aruquipa on 05/02/24.
//

import Foundation

struct PokemonListResponse: Decodable {
    struct PokemonLink: Decodable {
        let name: String
        let urlString: String
        
        private enum CodingKeys: String, CodingKey {
            case name
            case urlString = "url"
        }
    }
    
    let count: Int
    let nextUrlString: String?
    let prevUrlString: String?
    let results: [PokemonLink]
    
    private enum CodingKeys: String, CodingKey {
        case count
        case nextUrlString = "next"
        case prevUrlString = "previous"
        case results
    }
}
