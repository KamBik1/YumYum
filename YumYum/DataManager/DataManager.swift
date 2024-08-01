//
//  DataManager.swift
//  YumYum
//
//  Created by Kamil Biktineyev on 24.07.2024.
//

import Foundation

protocol DataManagerProtocol: AnyObject {
    func saveUser(user: User)
    func getUser() -> User
    func saveRecipe(recipe: [CleanDetailedRecipe])
    func getRecipe() -> [CleanDetailedRecipe]
}

final class DataManager: DataManagerProtocol {
    private let userDefaults = UserDefaults.standard
    private let userKey = "UserKey"
    private let recipeKey = "RecipeKey"
    
    // Определяем метод для сохранения User в User Defaults
    func saveUser(user: User) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(user)
            userDefaults.setValue(data, forKey: userKey)
        }
        catch {
            print("UserDefaultsSavingError: \(error.localizedDescription)")
        }
    }
    
    // Определяем метод для получения User из User Defaults
    func getUser() -> User {
        guard let data = userDefaults.data(forKey: userKey) else { return User(email: nil, uid: nil) }
        
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(User.self, from: data)
            return user
        }
        catch {
            print("UserDefaultsGettingError: \(error.localizedDescription)")
        }
        return User(email: nil, uid: nil)
    }
    
    // Определяем метод для сохранения рецепта в User Defaults (временное решение до внедрения Firebase Database)
    func saveRecipe(recipe: [CleanDetailedRecipe]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(recipe)
            userDefaults.setValue(data, forKey: recipeKey)
        }
        catch {
            print("UserDefaultsSavingError: \(error.localizedDescription)")
        }
    }
    
    // Определяем метод для получения рецепта из User Defaults (временное решение до внедрения Firebase Database)
    func getRecipe() -> [CleanDetailedRecipe] {
        guard let data = userDefaults.data(forKey: recipeKey) else { return [] }
        
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode([CleanDetailedRecipe].self, from: data)
            return user
        }
        catch {
            print("UserDefaultsGettingError: \(error.localizedDescription)")
        }
        return []
    }
}
