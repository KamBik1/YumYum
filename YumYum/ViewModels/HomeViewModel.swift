//
//  HomeViewModel.swift
//  YumYum
//
//  Created by Kamil Biktineyev on 24.07.2024.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    var firebaseManager: FirebaseManagerProtocol = FirebaseManager.shared
    var dataManager: DataManagerProtocol = DataManager()
    
    
    
    
    // Перенести в другую viewModel
    func logout() {
        firebaseManager.signOut()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("User logged out successfully")
                case .failure(let error):
                    print("Error signing out: \(error)")
                }
            }, receiveValue: { })
            .store(in: &cancellables)
        dataManager.saveUser(user: User(email: nil, uid: nil))
    }
    
}
