//
//  LoginViewModel.swift
//  YumYum
//
//  Created by Kamil Biktineyev on 22.07.2024.
//

import Foundation
import Combine

enum SignUpError: String {
    case invalidEmail = "Invalid email."
    case passwordsNotMatch = "Passwords do not match."
    case tooShort = "Password must be at least 8 characters long."
    case tooLong = "Password must be no more than 20 characters long."
    case missingUppercase = "Password must contain at least one uppercase letter."
    case missingLowercase = "Password must contain at least one lowercase letter."
    case missingDigit = "Password must contain at least one digit."
    case containsSpaces = "Password must not contain spaces."
    case noErrors = ""
    case processing = "Processing in progress."
    case success = "Success!"
}

final class LoginViewModel: ObservableObject {
    @Published var loginErrorMessage: String = ""
    @Published var signUpErrorMessage: String = ""
    @Published var isUserRegistered: Bool = false
    
    private var signUpEmailIsValid: Bool = false
    private var signUpPasswordIsValid: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    var firebaseManager: any FirebaseManagerProtocol = FirebaseManager.shared
    var dataManager: DataManagerProtocol = DataManager()
    
    init() {
        firebaseManager.isUserRegisteredPublisher
            .assign(to: \.isUserRegistered, on: self)
            .store(in: &cancellables)
    }
    
    // Проверка корректности email при Sign Up
    private func validateEmail(email: String) {
        signUpEmailIsValid = false
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if emailPredicate.evaluate(with: email) {
            signUpEmailIsValid = true
        } else {
            signUpErrorMessage = SignUpError.invalidEmail.rawValue
        }
    }
    
    // Проверка паролей на соответствие требованиям при Sign Up
    private func validatePasswords(firstPassword: String, secondPassword: String) {
        signUpPasswordIsValid = false
        if firstPassword != secondPassword {
            return signUpErrorMessage = SignUpError.passwordsNotMatch.rawValue
        }
        if firstPassword.count < 8 {
            return signUpErrorMessage = SignUpError.tooShort.rawValue
            }
        if firstPassword.count > 20 {
            return signUpErrorMessage = SignUpError.tooLong.rawValue
            }
        let upperCase = CharacterSet.uppercaseLetters
           if firstPassword.rangeOfCharacter(from: upperCase) == nil {
               return signUpErrorMessage = SignUpError.missingUppercase.rawValue
           }
        let lowerCase = CharacterSet.lowercaseLetters
            if firstPassword.rangeOfCharacter(from: lowerCase) == nil {
                return signUpErrorMessage = SignUpError.missingLowercase.rawValue
            }
        let digits = CharacterSet.decimalDigits
            if firstPassword.rangeOfCharacter(from: digits) == nil {
                return signUpErrorMessage = SignUpError.missingDigit.rawValue
            }
        if firstPassword.contains(" ") {
                return signUpErrorMessage = SignUpError.containsSpaces.rawValue
            }
        return signUpPasswordIsValid = true
    }
    
    // Регистрация новых пользователей (Sign Up)
    func signUp(email: String, password: String, confirmPassword: String) {
        validateEmail(email: email)
        validatePasswords(firstPassword: password, secondPassword: confirmPassword)
       
        if signUpEmailIsValid && signUpPasswordIsValid {
            signUpErrorMessage = SignUpError.processing.rawValue
            firebaseManager.signUp(email: email, password: password)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        self?.signUpErrorMessage = error.localizedDescription
                    case .finished:
                        break
                    }
                } receiveValue: { [weak self] user in
                    self?.signUpErrorMessage = SignUpError.success.rawValue
                    self?.dataManager.saveUser(user: user)
                    self?.isUserRegistered = true
                }
                .store(in: &cancellables)
        }
    }
    
    // Вход пользователей (Login)
    func login(email: String, password: String) {
        loginErrorMessage = ""
        firebaseManager.login(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.loginErrorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] user in
                self?.dataManager.saveUser(user: user)
                self?.isUserRegistered = true
            }
            .store(in: &cancellables)
    }
    
    
    // Забыл пароль (Forgot Password)
    func forgotPassword(email: String) {
        loginErrorMessage = ""
        guard !email.isEmpty else {
            loginErrorMessage = "Email cannot be empty."
            return
        }
        firebaseManager.passwordReset(email: email)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.loginErrorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] _ in
                self?.loginErrorMessage = "The password recovery letter was sent to your email."
            }
            .store(in: &cancellables)
    }
}
