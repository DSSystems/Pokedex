//
//  Pokemon.swift
//  Pokedex
//
//  Created by David Quispe Aruquipa on 05/02/24.
//

import Foundation

struct Pokemon: Identifiable, Hashable {
    var id: Int
    let name: String
    let isFavorite: Bool
}
