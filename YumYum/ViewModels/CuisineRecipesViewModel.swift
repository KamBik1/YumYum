//
//  CuisineRecipesViewModel.swift
//  YumYum
//
//  Created by Kamil Biktineyev on 30.07.2024.
//

import Foundation
import Combine

final class CuisineRecipesViewModel: ObservableObject, SearchRecipes {
    
    @Published var recipes: CleanRecipeResponse?
    
    private var cancellables = Set<AnyCancellable>()
    
    var networkManager: NetworkManagerProtocol = NetworkManager()
    
    // Запросы к API Запросы к API для поиска рецептов по национальной кухне
    func fetchCuisineRecipes(cuisine: String) {
        networkManager.fetchCuisineRecipes(cuisine: cuisine)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Fetch cuisine recipes error: \(error.localizedDescription)")
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
