//
//  PokemonDetailsView.swift
//  Pokedex
//
//  Created by David Quispe Aruquipa on 06/02/24.
//

import SwiftUI

struct DetailItemView: View {
    struct StringWrapper: Identifiable {
        var id: String { value }
        let value: String
    }
    
    let description: String
    let values: Array<StringWrapper>
    
    init<T>(description: String, values: [T]) {
        self.description = description
        self.values = values.map { value in
            StringWrapper(value: String(describing: value).capitalized)
        }
    }
    
    init<T>(description: String, value: T) {
        self.description = description
        self.values = [StringWrapper(value: String(describing: value))]
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text(description.uppercased())
                        .bold()
                    Spacer()
                }
                
                Spacer()
            }
            
            Divider()
            
            VStack {
                ForEach(values) { item in
                    HStack {
                        Spacer()
                        Text(item.value)
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
        .padding()
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 0.5).opacity(0.5))
    }
}

struct PokemonDetailsView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \FavoritePokemon.name, ascending: true)],
        animation: .default)
    private var favoritePokemons: FetchedResults<FavoritePokemon>
    
    let pokemonInfoModel: PokemonInfoModel
    
    var isFavorite: Bool {
        favoritePokemons.contains(where: { $0.name == pokemonInfoModel.name })
    }
    
    var body: some View {
        ScrollView {
            VStack {
                #if os(macOS)
                imageTabView
                #else
                imageTabView
                    .tabViewStyle(.page)
                    .frame(minHeight: 200)
                #endif

                HStack {
                    VStack {
                        HStack {
                            Text(pokemonInfoModel.name.uppercased())
                                .font(.title)
                                .bold()
                            Spacer()
                            Button(
                                isFavorite ? "\(Image(systemName: "minus.circle")) Favorites" : "\(Image(systemName: "plus.circle")) Favorites",
                                role: isFavorite ? .destructive : nil
                            ) {
                                if isFavorite {
                                    removeFromFavorites(pokemonId: pokemonInfoModel.id)
                                } else {
                                    addToFavorites()
                                }
                            }
                        }
                        
                        Divider()
                                                
                        DetailItemView(description: "Abilities", values: pokemonInfoModel.abilities.map { "\($0.name)" + ($0.isHidden ? " (hidden)" : "") })
                        
                        DetailItemView(description: "Stats", values: pokemonInfoModel.stats.map({ "\($0.name): \($0.value)" }))
                        
                        DetailItemView(description: "Type", values: pokemonInfoModel.types)
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
        }
    }
    
    private var imageTabView: some View {
        TabView {
            AsyncImage(url: pokemonInfoModel.frontImageUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 200)
            } placeholder: {
                ProgressView()
            }
            
            AsyncImage(url: pokemonInfoModel.backImageUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 200)
            } placeholder: {
                ProgressView()
            }
        }
    }
    
    private func addToFavorites() {
        withAnimation {
            let favoritePokemon = FavoritePokemon(context: viewContext)
            favoritePokemon.id = Int16(pokemonInfoModel.id)
            favoritePokemon.name = pokemonInfoModel.name

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unhandled error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func removeFromFavorites(pokemonId: Int) {
        withAnimation {
            guard let favoritePokemon = favoritePokemons.first(where: { $0.id == pokemonId }) else { return }
            
            viewContext.delete(favoritePokemon)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

#Preview {
    PokemonDetailsView(
        pokemonInfoModel: .init(
            id: 1,
            name: "bulbasaur",
            frontImageUrl: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")!,
            backImageUrl: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png")!,
            stats: [
                .init(name: "hp", value: 45),
                .init(name: "attack", value: 49)
            ],
            types: [
                "grass", "poison"
            ],
            abilities: [
                .init(name: "Ability", isHidden: false),
                .init(name: "Ability 2", isHidden: true)
            ]
        )
    )
}
