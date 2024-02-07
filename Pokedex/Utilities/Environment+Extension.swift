//
//  Environment+Extension.swift
//  Pokedex
//
//  Created by David Quispe Aruquipa on 05/02/24.
//

import Foundation
import SwiftUI
struct PokedexViewModelKey: EnvironmentKey {
    static var defaultValue: PokedexViewModel = PokedexViewModel()
}

extension EnvironmentValues {
    var pokedexViewModel: PokedexViewModel {
        get { self[PokedexViewModelKey.self] }
        set { self[PokedexViewModelKey.self] = newValue }
    }
}
