//
//  LoginView.swift
//  YumYum
//
//  Created by Kamil Biktineyev on 21.07.2024.
//

import SwiftUI

// Логин экран
struct LoginView: View {
   
    @State private var loginIsSelected: Bool = true
    @State private var signUpIsSelected: Bool = false
    @State private var isForgotPasswordTapped: Bool = false
    
    @State private var loginEmail: String = ""
    @State private var loginPassword: String = ""
    
    @State private var signUpEmail: String = ""
    @State private var signUpPassword: String = ""
    @State private var signUpConfirmPassword: String = ""
    
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        
        ZStack {
            BackgroundView()
            
            VStack {
                WelcomeText()
                    .padding(.top, 40)
                LoginSelectionButtons(loginIsSelected: $loginIsSelected, signUpIsSelected: $signUpIsSelected)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                if loginIsSelected {
                    LoginTextFields(email: $loginEmail, password: $loginPassword)
                    LoginButton(email: $loginEmail, password: $loginPassword, viewModel: viewModel)
                    ForgotPasswordButton(isForgotPasswordTapped: $isForgotPasswordTapped)
                        .padding(.top, 20)
                    InfoText(infoText: $viewModel.loginErrorMessage)
                        .padding(.top, 20)
                } else {
                    SignUpTextFields(email: $signUpEmail, password: $signUpPassword, confirmPassword: $signUpConfirmPassword)
                    SignUpButton(email: $signUpEmail, password: $signUpPassword, confirmPassword: $signUpConfirmPassword, viewModel: viewModel)
                    InfoText(infoText: $viewModel.signUpErrorMessage)
                        .padding(.top, 20)
                }
                Spacer()
            }
            .padding()
        }
        .onChange(of: viewModel.isUserRegistered) {
            loginIsSelected = true
            signUpIsSelected = false
            loginEmail = ""
            loginPassword = ""
            signUpEmail = ""
            signUpPassword = ""
            signUpConfirmPassword = ""
        }
        .hideKeyboardOnTap()
        .fullScreenCover(isPresented: $viewModel.isUserRegistered) {
            CustomTabView()
        }
        .sheet(isPresented: $isForgotPasswordTapped) {
            ForgotPasswordView(isForgotPasswordTapped: $isForgotPasswordTapped, viewModel: viewModel)
                .presentationDragIndicator(.visible)
        }
    }
}


struct WelcomeText: View {
    
    var body: some View {
        
        VStack {
            Text("Welcome")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 50))
                .foregroundColor(.yumText)
                .lineLimit(1)
            
            Text(" to Yum Yum")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 22))
                .foregroundColor(.yumText)
                .lineLimit(1)
        }
        .padding(.vertical)
    }
}


struct LoginSelectionButtons: View {
    
    @Binding var loginIsSelected: Bool
    @Binding var signUpIsSelected: Bool
    
    var body: some View {
        HStack {
            Button {
                withAnimation() {
                    loginIsSelected = true
                    signUpIsSelected = false
                }
            } label: {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .frame(height: 10)
                    .tint(.yumPurple)
            }
            .applyShadowStyle(loginIsSelected)
            
            Button {
                withAnimation() {
                    loginIsSelected = false
                    signUpIsSelected = true
                }
            } label: {
                Text("Sign Up")
                    .frame(maxWidth: .infinity)
                    .frame(height: 10)
                    .tint(.yumPurple)
            }
            .applyShadowStyle(signUpIsSelected)
        }
    }
}


struct LoginTextFields: View {
    
    @Binding var email: String
    @Binding var password: String
    
    var body: some View {
        TextField("Email", text: $email)
            .frame(height: 30)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .innerShadowsStyle()
            .transition(.scale)
        
        SecureField("Password", text: $password)
            .frame(height: 30)
            .textContentType(.password)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .innerShadowsStyle()
            .transition(.scale)
    }
}


struct SignUpTextFields: View {
    
    @Binding var email: String
    @Binding var password: String
    @Binding var confirmPassword: String
    
    var body: some View {
        TextField("Email", text: $email)
            .frame(height: 30)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .innerShadowsStyle()
            .transition(.scale)
        
        SecureField("Password", text: $password)
            .frame(height: 30)
            .textContentType(.newPassword)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .innerShadowsStyle()
            .transition(.scale)
        
        SecureField("Confirm password", text: $confirmPassword)
            .frame(height: 30)
            .textContentType(.newPassword)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .innerShadowsStyle()
            .transition(.scale)
    }
}


struct LoginButton: View {
    
    @Binding var email: String
    @Binding var password: String
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        Button {
            viewModel.login(email: email, password: password)
            UIApplication.shared.endEditing()
        } label: {
            Text("Log in")
                .frame(maxWidth: .infinity)
                .frame(height: 30)
                .font(.system(size: 20))
                .tint(.yumBackground)
                
        }
        .padding()
        .background(.yumPurple)
        .cornerRadius(20)
        .transition(.scale)
    }
}


struct SignUpButton: View {
    
    @Binding var email: String
    @Binding var password: String
    @Binding var confirmPassword: String
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        Button {
            viewModel.signUp(email: email, password: password, confirmPassword: confirmPassword)
            UIApplication.shared.endEditing()
        } label: {
            Text("Sign up")
                .frame(maxWidth: .infinity)
                .frame(height: 30)
                .font(.system(size: 20))
                .tint(.yumBackground)
                
        }
        .padding()
        .background(.yumPurple)
        .cornerRadius(20)
        .transition(.scale)
    }
}


struct ForgotPasswordButton: View {
    
    @Binding var isForgotPasswordTapped: Bool
    
    var body: some View {
        Button {
            isForgotPasswordTapped = true
        } label: {
            Text("Forgot Password?")
                .tint(.yumPurple)
        }
    }
}


struct InfoText: View {
    
    @Binding var infoText: String
    
    var body: some View {
        Text(infoText)
            .frame(maxWidth: .infinity)
            .foregroundColor(.yumChestnut)
            .multilineTextAlignment(.center)
            .lineLimit(2)
    }
}


// Экран восстановления пароля
struct ForgotPasswordView: View {
    
    @State private var email: String = ""
    
    @Binding var isForgotPasswordTapped: Bool
    
    @FocusState private var isFocused: Bool
    
    @ObservedObject var viewModel: LoginViewModel
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                Text("Forgot your password")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .font(.system(size: 22))
                    .foregroundColor(.yumText)
                    .padding(.top, 15)
                
                TextField("Email", text: $email)
                    .frame(height: 30)
                    .keyboardType(.emailAddress)
                    .focused($isFocused)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .innerShadowsStyle()
                    .padding(.top, 15)
                
                Text("We will send you an email with a password reset link")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.yumText)
                
                Button {
                    viewModel.forgotPassword(email: email)
                    isForgotPasswordTapped = false
                } label: {
                    Text("Send reset email")
                        .frame(maxWidth: .infinity)
                        .frame(height: 30)
                        .font(.system(size: 20))
                        .tint(.yumBackground)
                        
                }
                .padding()
                .background(.yumPurple)
                .cornerRadius(20)
                
                Spacer()
            }
            .padding()
            .onAppear {
                isFocused = true
            }
        }
    }
}



//#Preview {
//    LoginView()
//}
