//
//  SearchResultsViewModel.swift
//  YumYum
//
//  Created by Kamil Biktineyev on 31.07.2024.
//

import Foundation
import Combine

protocol SearchRecipes: ObservableObject {
    var recipes: CleanRecipeResponse? { get }
}

class SearchResultsViewModel: ObservableObject, SearchRecipes {
    @Published var recipes: CleanRecipeResponse?
    
    private var cancellables = Set<AnyCancellable>()
    
    var networkManager: NetworkManagerProtocol = NetworkManager()
    
    // Запросы к API для поиска конкретного рецепта
    func fetchSpecificRecipe(specificRecipe: String) {
        networkManager.fetchSpecificRecipe(specificRecipe: specificRecipe)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Fetch specific recipe error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] resipesResponse in
                let cleanResipes = CleanRecipeResponse(from: resipesResponse)
                self?.recipes = cleanResipes
            })
            .store(in: &cancellables)
    }
}
