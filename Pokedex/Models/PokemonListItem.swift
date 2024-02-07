//
//  PokemonListItem.swift
//  Pokedex
//
//  Created by David Quispe Aruquipa on 05/02/24.
//

import Foundation

struct PokemonListItem: Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
    let url: URL?
}
