//
//  SharedViewModel.swift
//  YumYum
//
//  Created by Kamil Biktineyev on 31.07.2024.
//

import Foundation
import Combine

// ViewModel для сохранения рецептов из DetailedRecipeView в FavoritesView
class SharedViewModel: ObservableObject {
    
    @Published var sharedRecipes: [CleanDetailedRecipe] {
        didSet {
            // Временное решение до внедрения Firebase Database
            dataManager.saveRecipe(recipe: sharedRecipes)
        }
    }

    var dataManager: DataManagerProtocol = DataManager()
    
    init() {
        // Временное решение до внедрения Firebase Database
        self.sharedRecipes = dataManager.getRecipe()
    }
    
    // Сохранение в раздел Favorites
    func saveToFavorites(recipe: CleanDetailedRecipe?) {
        guard var recipe = recipe else { return }
        recipe.isSelected = true
        sharedRecipes.append(recipe)
    }
    
    // Удаление из раздела Favorites
    func deleteFromFavorites(recipe: CleanDetailedRecipe?) {
        guard let recipe = recipe else { return }
        for index in 0..<sharedRecipes.count {
            if sharedRecipes[index].id == recipe.id {
                sharedRecipes.remove(at: index)
                break
            }
        }
    }
    
    // Удаление из раздела Favorites по ID
    func deleteFromFavoritesWithID(recipeID: Int) {
        for index in 0..<sharedRecipes.count {
            if sharedRecipes[index].id == recipeID {
                sharedRecipes.remove(at: index)
                break
            }
        }
    }
}
