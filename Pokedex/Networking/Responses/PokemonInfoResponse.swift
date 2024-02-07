//
//  PokemonInfoResponse.swift
//  Pokedex
//
//  Created by David Quispe Aruquipa on 05/02/24.
//

import Foundation

struct PokemonInfoResponse: Decodable {
    struct SpriteURLs: Decodable {
        let frontDefault: String
        let backDefault: String
    }
    
    struct PokemonType: Decodable {
        struct Info: Decodable {
            let name: String
        }
        
        let slot: Int
        let info: Info
        
        private enum CodingKeys: String, CodingKey {
            case slot
            case info = "type"
        }
    }
    
    struct Stat: Decodable {
        struct Name: Decodable {
            let value: String
            
            private enum CodingKeys: String, CodingKey {
                case value = "name"
            }
        }
        
        let name: Name
        let baseStat: Int
        let effort: Int
        
        private enum CodingKeys: String, CodingKey {
            case name = "stat"
            case baseStat
            case effort
        }
    }
    
    struct Ability: Decodable {
        struct Name: Decodable {
            let value: String
            let urlString: String
            
            private enum CodingKeys: String, CodingKey {
                case value = "name"
                case urlString = "url"
            }
        }
        
        let name: Name
        let isHidden: Bool
        
        private enum CodingKeys: String, CodingKey {
            case name = "ability"
            case isHidden
        }
    }
    
    struct Move: Decodable {
        struct Name: Decodable {
            let value: String
            
            private enum CodingKeys: String, CodingKey {
                case value = "name"
            }
        }
        
        let name: Name
        
        private enum CodingKeys: String, CodingKey {
            case name = "move"
        }
    }
    
    let id: Int
    let name: String
    let baseExperience: Int
    let height: Int
    let isDefault: Bool
    let order: Int
    let weight: Int
    let sprites: SpriteURLs
    let stats: [Stat]
    let abilities: [Ability]
    let moves: [Move]
    let types: [PokemonType]
}
