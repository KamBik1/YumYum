//
//  FirebaseManager.swift
//  YumYum
//
//  Created by Kamil Biktineyev on 23.07.2024.
//

import Foundation
import Firebase
import Combine

protocol FirebaseManagerProtocol {
    var isUserRegisteredPublisher: AnyPublisher<Bool, Never> { get }
    func signUp(email: String, password: String) -> Future<User, Error>
    func login(email: String, password: String) -> Future<User, Error>
    func signOut() -> AnyPublisher<Void, Error>
    
    //Удалить
    func authCheck(complition: @escaping (User) -> ())
}

final class FirebaseManager: FirebaseManagerProtocol, ObservableObject {
    
    @Published private var isUserRegistered: Bool = false
    
    var isUserRegisteredPublisher: AnyPublisher<Bool, Never> {
        $isUserRegistered.eraseToAnyPublisher()
    }
    
    static let shared = FirebaseManager()
    
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    private init() {
        // Проверка текущего состояния аутентификации
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.isUserRegistered = user != nil
        }
    }
    
    // Определяем метод для Sign Up
    func signUp(email: String, password: String) -> Future<User, Error> {
        Future { promise in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                } else if let user = authResult?.user {
                    promise(.success(User(email: user.email, uid: user.uid)))
                }
            }
        }
    }
    
    // Определяем метод для Login
    func login(email: String, password: String) -> Future<User, Error> {
        Future { promise in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                } else if let user = authResult?.user {
                    promise(.success(User(email: user.email, uid: user.uid)))
                }
            }
        }
    }
    
    // Определяем метод для Sign Out
    func signOut() -> AnyPublisher<Void, Error> {
        Future<Void, Error> { promise in
            do {
                try Auth.auth().signOut()
                promise(.success(()))
            } catch let error {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    
    
    // Удалить!
    func authCheck(complition: @escaping (User) -> ()) {
        Auth.auth().addStateDidChangeListener { _, user in
            let myUser = User(email: user?.email, uid: user?.uid)
            complition(myUser)
        }
    }
    
    
  
    
    
    deinit {
        // Удаляем слушатель состояния аутентификации при деинициализации
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    
}
