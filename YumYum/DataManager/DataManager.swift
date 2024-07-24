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
}

final class DataManager: DataManagerProtocol {
    private let userDefaults = UserDefaults.standard
    private let key = "UserKey"
    
    // Определяем метод для сохранения User в User Defaults
    func saveUser(user: User) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(user)
            userDefaults.setValue(data, forKey: key)
        }
        catch {
            print("UserDefaultsSavingError: \(error)")
        }
    }
    
    // Определяем метод для получения User из User Defaults
    func getUser() -> User {
        guard let data = userDefaults.data(forKey: key) else { return User(email: nil, uid: nil) }
        
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(User.self, from: data)
            return user
        }
        catch {
            print("UserDefaultsGettingError: \(error)")
        }
        return User(email: nil, uid: nil)
    }
}
