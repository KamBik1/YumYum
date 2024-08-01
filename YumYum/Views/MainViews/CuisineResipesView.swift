//
//  CuisineResipesView.swift
//  YumYum
//
//  Created by Kamil Biktineyev on 28.07.2024.
//

import SwiftUI

//Экран с найденными рецептами по национальной кухне
struct CuisineResipesView: View {
    
    @Binding var cuisineRecipeViewIsPresented: Bool
    
    @StateObject private var viewModel = CuisineRecipesViewModel()
    
    let cuisine: String
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                BackgroundView()
                VStack {
                    ResipesTableView(viewModel: viewModel)
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.hidden)
                }
            }
            .onAppear {
                viewModel.fetchCuisineRecipes(cuisine: cuisine.lowercased())
            }
            .navigationTitle(cuisine)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation {
                            cuisineRecipeViewIsPresented = false
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .tint(.yumText)
                    }
                }
            }
        }
    }
}
    
