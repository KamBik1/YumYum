//
//  RecipesTableView.swift
//  YumYum
//
//  Created by Kamil Biktineyev on 30.07.2024.
//

import SwiftUI

struct ResipesTableView<T: SearchRecipes>: View {
    
    @StateObject var viewModel: T
    
    var body: some View {
        List(viewModel.recipes?.results ?? []) { recipe in
            NavigationLink(destination: DetailedRecipeView(recipeID: recipe.id)) {
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
    
