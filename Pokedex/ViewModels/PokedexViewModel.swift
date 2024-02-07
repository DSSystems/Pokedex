//
//  PokedexViewModel.swift
//  Pokedex
//
//  Created by David Quispe Aruquipa on 05/02/24.
//

import Foundation
import Combine

extension PokemonListItem {
    init?(_ rLink: PokemonListResponse.PokemonLink) {
        guard let url = URL(string: rLink.urlString) else { return nil }
        guard let id = Int(url.lastPathComponent) else { return nil }
        self.init(id: id, name: rLink.name, url: url)
    }
}

extension PokemonInfoModel.Ability {
    init(_ rAbility: PokemonInfoResponse.Ability) {
        self.init(name: rAbility.name.value, isHidden: rAbility.isHidden)
    }
}

extension PokemonInfoModel {
    init?(_ infoResponse: PokemonInfoResponse) {
        guard let frontImageUrl = URL(string: infoResponse.sprites.frontDefault),
              let backImageUrl = URL(string: infoResponse.sprites.backDefault)
        else { return nil }
        
        let stats: [Stat] = infoResponse.stats.map { stat in
            Stat(name: stat.name.value, value: stat.baseStat)
        }
        
        self.init(
            id: infoResponse.id,
            name: infoResponse.name,
            frontImageUrl: frontImageUrl,
            backImageUrl: backImageUrl,
            stats: stats,
            types: infoResponse.types.map(\.info.name),
            abilities: infoResponse.abilities.map(Ability.init)
        )
    }
}

class PokedexViewModel: ObservableObject {
    @Published var pokemonList: [PokemonListItem] = []
    
    @Published var pokemonInfoModel: PokemonInfoModel?
    
    private let networkService = NetworkService()
    
    var subscriptions = Set<AnyCancellable>()
    
    func fetchInfo(forPokemon name: String) {
        pokemonInfoModel = nil
        guard let request = try? networkService.getRequest(forPath: "api/v2/pokemon/\(name)") else { return }
        
        networkService.fetch(request: request, responseType: PokemonInfoResponse.self)
            .receive(on: RunLoop.main)
            .compactMap { infoResponse -> PokemonInfoModel? in
                PokemonInfoModel(infoResponse)
            }
            .sink { completion in
                switch completion {
                case .finished:()
                case .failure(let error):
                    print("Unhandled error: \(error)")
                }
            } receiveValue: { infoModel in
                self.pokemonInfoModel = infoModel
            }
            .store(in: &subscriptions)

    }
    
    func fetch(for listType: PokemonListType) {
        guard let request = try? networkService.getRequest(forPath: "api/v2/pokemon") else { return }
        
        networkService.fetch(request: request, responseType: PokemonListResponse.self)
            .receive(on: RunLoop.main)
            .map(\.results)
            .map { pokemonLinkList -> [PokemonListItem] in
                pokemonLinkList.compactMap(PokemonListItem.init)
            }
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:()
                case .failure(let error):
                    print("Unhandled error: \(error)")
                }
            }, receiveValue: { [weak self] pokemonLinks in
                self?.pokemonList = pokemonLinks
            })
            .store(in: &subscriptions)
    }
}
