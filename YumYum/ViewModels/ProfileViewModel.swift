//
//  ProfileViewModel.swift
//  YumYum
//
//  Created by Kamil Biktineyev on 24.07.2024.
//

import Foundation
import UIKit
import Combine
import PhotosUI
import _PhotosUI_SwiftUI

final class ProfileViewModel: ObservableObject {
    
    @Published var selectedPhoto: PhotosPickerItem? {
        didSet {
            if let selectedPhoto = selectedPhoto {
                processPhoto(photo: selectedPhoto)
            }
        }
    }
    @Published var loadedImage: UIImage?
    
    private var cancellables = Set<AnyCancellable>()
    
    var firebaseManager: FirebaseManagerProtocol = FirebaseManager.shared
    var dataManager: DataManagerProtocol = DataManager()
    
    var userEmail: String
    
    init() {
        let email = dataManager.getUser().email
        userEmail = email ?? "User email"
    }
    
    // Загрузка фото из библиотеки
    func processPhoto(photo: PhotosPickerItem) {
        photo.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    guard let data = data else { return }
                    let image = UIImage(data: data)
                    self.loadedImage = image
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // Установка Dark Mode и Light Mode
    func changeTheme(isDarkMode: Bool) {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        windowScene?.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
    }
    
    // Выход из учетной записи (Log Out)
    func logout() {
        firebaseManager.signOut()
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.dataManager.saveUser(user: User(email: nil, uid: nil))
                case .failure(let error):
                    print("Logout error: \(error.localizedDescription)")
                }
            }, receiveValue: { })
            .store(in: &cancellables)
        dataManager.saveUser(user: User(email: nil, uid: nil))
        dataManager.saveRecipe(recipe: []) // Убрать после внедрения Firebase Database
    }
}
