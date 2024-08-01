//
//  DetailedRecipeViewModel.swift
//  YumYum
//
//  Created by Kamil Biktineyev on 30.07.2024.
//

import Foundation
import Combine

final class DetailedRecipeViewModel: ObservableObject {
    
    @Published var detailedRecipe: CleanDetailedRecipe?
    
    private var cancellables = Set<AnyCancellable>()
    
    var networkManager: NetworkManagerProtocol = NetworkManager()
    
    // Запрос детальной информации по рецепту к API
    func fetchDetailedRecipe(recipeID: Int) {
        networkManager.fetchDetailedRecipe(recipeID: recipeID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Fetch detailed recipe error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] recipe in
                let cleanRecipe = CleanDetailedRecipe(from: recipe)
                self?.detailedRecipe = cleanRecipe
            })
            .store(in: &cancellables)
    }
}
