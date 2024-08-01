//
//  Recipe.swift
//  YumYum
//
//  Created by Kamil Biktineyev on 27.07.2024.
//

import Foundation

// Модель данных API
struct MealAutocomplete: Codable, Hashable {
    let id: Int
    let title: String
}

// Модель данных для видов национальной кухни
struct Cuisine: Hashable, Identifiable {
    let id: Int
    let title: String
    let image: String
}

// Модель данных API
struct RecipeResponse: Codable {
    let offset: Int
    let number: Int
    let results: [Recipe]
    let totalResults: Int
}

// Модель данных API
struct Recipe: Codable {
    let id: Int
    let title: String
    let image: String
}

// Преобразуем модель данных от API в свою модель
struct CleanRecipeResponse: Identifiable {
    let id: UUID = UUID()
    let offset: Int
    let number: Int
    let results: [CleanRecipe]
    let totalResults: Int
    
    init(from recipeResponse: RecipeResponse ) {
        self.offset = recipeResponse.offset
        self.number = recipeResponse.number
        self.results = recipeResponse.results.map { CleanRecipe(from: $0) }
        self.totalResults = recipeResponse.totalResults
    }
}

// Преобразуем модель данных от API в свою модель
struct CleanRecipe: Identifiable, Hashable {
    let id: Int
    let title: String
    let image: String
    var isSelected: Bool = false
    
    init(from recipe: Recipe) {
        self.id = recipe.id
        self.title = recipe.title
        self.image = recipe.image
    }
}

// Модель данных API
struct DetailedRecipe: Codable {
    let id: Int
    let title: String
    let image: String
    let servings: Int
    let readyInMinutes: Int
    let extendedIngredients: [Ingredients]
}

// Модель данных API
struct Ingredients: Codable {
    let id: Int
    let original: String
}

// Преобразуем модель данных от API в свою модель
struct CleanDetailedRecipe: Codable, Identifiable {
    let id: Int
    let title: String
    var image: String
    let servings: Int
    let readyInMinutes: Int
    let extendedIngredients: [CleanIngredients]
    var isSelected: Bool = false
    
    init(from detailedRecipe: DetailedRecipe) {
        self.id = detailedRecipe.id
        self.title = detailedRecipe.title
        self.image = detailedRecipe.image
        self.servings = detailedRecipe.servings
        self.readyInMinutes = detailedRecipe.readyInMinutes
        self.extendedIngredients = detailedRecipe.extendedIngredients.map { CleanIngredients(from: $0) }
    }
}

// Преобразуем модель данных от API в свою модель
struct CleanIngredients: Codable, Hashable {
    let id: UUID
    let original: String
    
    init(from ingredients: Ingredients) {
        self.id = UUID()
        self.original = ingredients.original
    }
}
