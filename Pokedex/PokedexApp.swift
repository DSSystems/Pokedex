//
//  PokedexApp.swift
//  Pokedex
//
//  Created by David Quispe Aruquipa on 03/02/24.
//

import SwiftUI

@main
struct PokedexApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
