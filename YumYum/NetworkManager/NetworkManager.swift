//
//  NetworkManager.swift
//  YumYum
//
//  Created by Kamil Biktineyev on 27.07.2024.
//

import Foundation
import Combine

protocol NetworkManagerProtocol {
    func fetchMealAutocomplete(searchingMeal: String) -> AnyPublisher<[MealAutocomplete], Error>
    func fetchCuisineRecipes(cuisine: String) -> AnyPublisher<RecipeResponse, Error>
    func fetchSpecificRecipe(specificRecipe: String) -> AnyPublisher<RecipeResponse, Error>
    func fetchDetailedRecipe(recipeID: Int) -> AnyPublisher<DetailedRecipe, Error>
}

final class NetworkManager: NetworkManagerProtocol {
    
    private let apiKey = "317a77bf820341a09f88e9b70cde876e"
    
    // Запросы к API для Meal Autocomplete
    func fetchMealAutocomplete(searchingMeal: String) -> AnyPublisher<[MealAutocomplete], Error> {
        guard let url = URL(string: "https://api.spoonacular.com/recipes/autocomplete?number=10&query=\(searchingMeal)&apiKey=\(apiKey)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [MealAutocomplete].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    // Запросы к API для поиска рецептов по национальной кухне
    func fetchCuisineRecipes(cuisine: String) -> AnyPublisher<RecipeResponse, Error> {
        guard let url = URL(string: "https://api.spoonacular.com/recipes/complexSearch?cuisine=\(cuisine)&number=15&apiKey=\(apiKey)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: RecipeResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    // Запросы к API для поиска конкретного рецепта
    func fetchSpecificRecipe(specificRecipe: String) -> AnyPublisher<RecipeResponse, Error> {
        guard let url = URL(string: "https://api.spoonacular.com/recipes/complexSearch?query=\(specificRecipe)&number=15&apiKey=\(apiKey)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: RecipeResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    // Запрос детальной информации по рецепту к API
    func fetchDetailedRecipe(recipeID: Int) -> AnyPublisher<DetailedRecipe, Error> {
        let stringRecipeID = String(recipeID)
        guard let url = URL(string: "https://api.spoonacular.com/recipes/\(stringRecipeID)/information?includeNutrition=falsen&apiKey=\(apiKey)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: DetailedRecipe.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
