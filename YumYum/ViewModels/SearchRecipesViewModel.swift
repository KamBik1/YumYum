//
//  SearchRecipesViewModel.swift
//  YumYum
//
//  Created by Kamil Biktineyev on 28.07.2024.
//

import Foundation
import Combine

class SearchRecipesViewModel: ObservableObject {
    
    @Published var searchItems: [MealAutocomplete] = [
        MealAutocomplete(id: 0, title: "chicken"),
        MealAutocomplete(id: 1, title: "fish"),
        MealAutocomplete(id: 2, title: "pasta"),
        MealAutocomplete(id: 3, title: "pizza"),
        MealAutocomplete(id: 4, title: "egg"),
        MealAutocomplete(id: 5, title: "potato")
    ]
    
    private var cancellables = Set<AnyCancellable>()
    
    var networkManager: NetworkManagerProtocol = NetworkManager()
    
    // Запросы к API для Meal Autocomplete
    func fetchMealAutocomplete(searchingMeal: String) {
        networkManager.fetchMealAutocomplete(searchingMeal: searchingMeal)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Fetch meal autocomplete error: \(error.localizedDescription)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] meals in
                self?.searchItems = meals
            })
            .store(in: &cancellables)
    }
}
