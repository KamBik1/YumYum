//
//  FavoritesView.swift
//  YumYum
//
//  Created by Kamil Biktineyev on 25.07.2024.
//

import SwiftUI

// Экран, на котором отображаются сохраненные рецепты
struct FavoritesView: View {
    
    @EnvironmentObject var sharedViewModel: SharedViewModel
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                BackgroundView()
                
                VStack {
                    if sharedViewModel.sharedRecipes.count > 0 {
                        FavoritesTableView()
                            .scrollContentBackground(.hidden)
                            .scrollIndicators(.hidden)
                    } else {
                        Text("Nothing added yet")
                            .foregroundColor(.yumText)
                            .padding(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [2]))
                                    .foregroundColor(.yumText)
                            )
                    }
                }
                .navigationTitle("Your favorite recipes")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}


struct FavoritesTableView: View {
    
    @EnvironmentObject var sharedViewModel: SharedViewModel
    
    var body: some View {
        List(sharedViewModel.sharedRecipes) { recipe in
            NavigationLink(destination: SavedDetailedView(recipeID: recipe.id, recipeTitle: recipe.title, recipeImage: recipe.image, readyInMinutes: recipe.readyInMinutes, extendedIngredients: recipe.extendedIngredients)) {
                HStack {
                    AsyncImage(url: URL(string: recipe.image)) { result in
                        switch result {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .frame(width: 80, height: 80)
                                .aspectRatio(contentMode: .fill)
                                .cornerRadius(20)
                                .padding(.leading, 5)
                        case .failure:
                            Image(systemName: "xmark.circle")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .aspectRatio(contentMode: .fill)
                                .cornerRadius(20)
                                .foregroundColor(.yumText)
                                .padding(.leading, 5)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    Text(recipe.title)
                        .font(.system(size: 16))
                        .foregroundColor(.yumText)
                        .lineLimit(4)
                        .padding(.leading, 5)
                    Spacer()
                }
               
            }
            .frame(maxWidth: .infinity)
            .frame(height: 90)
            .listRowSeparator(.hidden)
            .outerShadowsStyle()
            .listRowBackground(Color.yumBackground)
        }
    }
}
