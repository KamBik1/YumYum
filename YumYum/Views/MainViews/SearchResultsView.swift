//
//  SearchResultsView.swift
//  YumYum
//
//  Created by Kamil Biktineyev on 31.07.2024.
//

import SwiftUI

// Экран с результатами поиска конкретного рецепта
struct SearchResultsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var searchingRecipe: String
    
    @StateObject private var viewModel = SearchResultsViewModel()
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                ResipesTableView(viewModel: viewModel)
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
            }
        }
        .onAppear {
            viewModel.fetchSpecificRecipe(specificRecipe: searchingRecipe.lowercased())
        }
        .navigationTitle("Search results for \"\(searchingRecipe)\"")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    withAnimation {
                        presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .tint(.yumText)
                }
            }
            
        }
    }
}
