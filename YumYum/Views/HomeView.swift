//
//  HomeView.swift
//  YumYum
//
//  Created by Kamil Biktineyev on 24.07.2024.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    
    var firebaseManager: FirebaseManagerProtocol = FirebaseManager.shared
    
    var body: some View {
        VStack {
            Text("Welcome home")
            
            Button {
                firebaseManager.authCheck { user in
                    print("Check auth \(user)")
                }
            } label: {
                Text("Check auth")
                    .tint(.yumPurple)
            }
            
            
            Button {
                viewModel.logout()
            } label: {
                Text("Log out")
                    .tint(.yumPurple)
            }
            
            
        }
        .navigationTitle("Home")
        .navigationBarBackButtonHidden(true)
    }
    
    
    
}

