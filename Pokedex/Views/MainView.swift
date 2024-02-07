//
//  MainView.swift
//  Pokedex
//
//  Created by David Quispe Aruquipa on 03/02/24.
//

import SwiftUI
import CoreData

struct MainView: View {
    @Environment(\.pokedexViewModel)
    var pokedexViewModel: PokedexViewModel
    
    @State var sideBarVisibility: NavigationSplitViewVisibility = .all
    
    #if !(os(visionOS) || os(iOS))
    @State var currentSelectionItem: PokemonListType = .all
    #endif
    let listTypeItems: [PokemonListType] = PokemonListType.allCases
    #if os(visionOS) || os(iOS)
    @State var currentListTypeId: Int = PokemonListType.all.id
    #endif

    var body: some View {
        #if os(visionOS) || os(iOS)
        TabView(selection: $currentListTypeId) {
            ForEach(listTypeItems) { item in
                PokemonListView(listType: item, pokedexViewModel: pokedexViewModel)
                    .tabItem {
                        Label(item.rawValue.capitalized, systemImage: item.systemImage)
                    }
                    .tag(item.id)
            }
        }
        #else
        TabView(selection: $currentSelectionItem) {
            List(listTypeItems) { item in
//                PokemonListView(listType: item, pokedexViewModel: pokedexViewModel)
                Text(item.rawValue)
                    .tabItem {
                        VStack {
                            Text(item.rawValue.capitalized)
                        }
//                        Label(item.rawValue.capitalized, systemImage: item.systemImage)
                    }
                    .tag(item)
            }
        }
        
//        NavigationSplitView(columnVisibility: $sideBarVisibility) {
//            List(PokemonListType.allCases, selection: $currentSelectionItem) { item in
//                Text(item.rawValue.capitalized)
//            }
//        } content: {
//            Text("Content")
//        } detail: {
//            Text("Detail")
//        }
//        .navigationTitle("Test")
        #endif
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    MainView()
//        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
