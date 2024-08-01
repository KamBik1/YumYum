//
//  ProfileView.swift
//  YumYum
//
//  Created by Kamil Biktineyev on 25.07.2024.
//

import SwiftUI
import PhotosUI

// Экран профиля пользователя
struct ProfileView: View {
    
    @State private var isDarkMode: Bool = false
    @State private var exitButton: Bool = false
    
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        
        ZStack {
            BackgroundView()
            
            VStack {
                ProfilePhotoEmail(viewModel: viewModel)
                    .padding(.top, 30)
                DarkMode(isDarkMode: $isDarkMode, viewModel: viewModel)
                    .padding(.top, 80)
                LogoutButton(exitButton: $exitButton, viewModel: viewModel)
                    .padding(.top, 30)
                Spacer()
            }
        }
    }
}

struct ProfilePhotoEmail: View {
 
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        VStack {
            if let image = viewModel.loadedImage {
                PhotosPicker(selection: $viewModel.selectedPhoto, matching: .images) {
                    Image(uiImage: image)
                        .resizable()
                        .foregroundColor(.yumText)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .outerShadowsStyle()
                }
            } else {
                PhotosPicker(selection: $viewModel.selectedPhoto, matching: .images) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(.yumText)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .outerShadowsStyle()
                }
            }
            Text(viewModel.userEmail)
                .foregroundColor(.yumText)
                .font(.system(size: 25))
                .lineLimit(1)
                .padding(.top, 10)
        }
    }
}


struct DarkMode: View {
    
    @Binding var isDarkMode: Bool
 
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        
        HStack {
            Spacer()
            Text("Dark Mode")
                .foregroundColor(.yumText)
            Spacer()
            ZStack {
                Rectangle()
                    .frame(width: 100, height: 20)
                    .foregroundColor(.yumBackground)
                    .outerShadowsStyle()
                
                HStack {
                    Button {
                        withAnimation {
                            isDarkMode.toggle()
                            viewModel.changeTheme(isDarkMode: isDarkMode)
                        }
                    } label: {
                        if isDarkMode {
                            Spacer()
                            Text("ON")
                                .frame(width: 35, height: 15)
                                .foregroundColor(.yumPurple)
                                .innerShadowsStyle()
                                .padding(.trailing, 4)
                                .transition(.scale)
                        } else {
                            Text("OFF")
                                .frame(width: 35, height: 15)
                                .foregroundColor(.yumPurple)
                                .innerShadowsStyle()
                                .padding(.leading, 4)
                                .transition(.scale)
                            Spacer()
                        }
                    }
                }
            }
            .frame(width: 100, height: 20)
            .padding(.trailing, 57)
        }
    }
}


struct LogoutButton: View {
 
    @Binding var exitButton: Bool
    
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        
        HStack {
            Spacer()
            Text("Logout")
                .foregroundColor(.yumText)
            Spacer()
            Button {
                withAnimation {
                    exitButton.toggle()
                }
                viewModel.logout()
            } label: {
               
                if exitButton {
                    Text("EXIT")
                        .frame(width: 100, height: 20)
                        .foregroundColor(.yumChestnut)
                        .innerShadowsStyle()
                    
                } else {
                    Text("EXIT")
                        .frame(width: 100, height: 20)
                        .foregroundColor(.yumChestnut)
                        .outerShadowsStyle()
                }
            }
            .padding(.trailing, 40)
        }
    }
}
