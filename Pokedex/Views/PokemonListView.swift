//
//  PokemonListView.swift
//  Pokedex
//
//  Created by David Quispe Aruquipa on 06/02/24.
//

import SwiftUI

extension PokemonListItem {
    init(_ favoritePokemon: FavoritePokemon) {
        self.init(
            id: Int(favoritePokemon.id),
            name: favoritePokemon.name ?? "No name",
            url: favoritePokemon.url
        )
    }
}

struct PokemonListView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FavoritePokemon.name, ascending: true)],
        animation: .default)
    private var favoritePokemons: FetchedResults<FavoritePokemon>
    
    let listType: PokemonListType
    
    @ObservedObject var pokedexViewModel: PokedexViewModel
    
    @State var selectedPokemon: PokemonListItem? = nil
    
    var body: some View {
        NavigationSplitView {
            #if os(visionOS)
            List(
                listType == .all ?
                pokedexViewModel.pokemonList : favoritePokemons.map(PokemonListItem.init)
            ) { pokemon in
                Button(action: {
                    selectedPokemon = pokemon
                }, label: {
                    HStack {
                        Text(pokemon.name.capitalized)
                        
                        Spacer()
                        
                        if selectedPokemon?.id == pokemon.id {
                            Image(systemName: "chevron.forward")
                        }
                    }
                })
            }
            .onAppear {
                pokedexViewModel.fetch(for: listType)
            }
            #else
            List(
                listType == .all ?
                 pokedexViewModel.pokemonList : favoritePokemons.map(PokemonListItem.init),
                selection: $selectedPokemon) { item in
                    NavigationLink(value: item) {
                        HStack {
                            Text(item.name.capitalized)
                            
                            Spacer()
                            
                            if selectedPokemon?.id == item.id {
                                Image(systemName: "chevron.forward")
                            }
                        }
                    }
                }
            #endif
        } detail: {
            VStack {
                if let model = pokedexViewModel.pokemonInfoModel {
                    PokemonDetailsView(pokemonInfoModel: model)
                        .frame(maxWidth: 400)
                }
                else {
                    Text("Select a Pokémon to see its information.")
                }
                
                Spacer()
            }
            .onChange(of: selectedPokemon) { oldValue, newValue in
                if let selectedPokemon {
                    pokedexViewModel.fetchInfo(forPokemon: selectedPokemon.name)
                }
            }
            .navigationTitle(listType.rawValue.uppercased())
        }
    }
}

#Preview {
    PokemonListView(listType: .all, pokedexViewModel: PokedexViewModel(), selectedPokemon: nil)
}
