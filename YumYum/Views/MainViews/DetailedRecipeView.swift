//
//  DetailedRecipeView.swift
//  YumYum
//
//  Created by Kamil Biktineyev on 30.07.2024.
//

import SwiftUI

// Экран с детальным описанием рецепта
struct DetailedRecipeView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sharedViewModel: SharedViewModel
    
    @StateObject private var viewModel = DetailedRecipeViewModel()
    
    let recipeID: Int
    
    var body: some View {
        
        ZStack {
            BackgroundView()
            
            VStack {
                ScrollView(showsIndicators: false) {
                    DetailedRecipeImage(viewModel: viewModel)
                    DetailedRecipeName(viewModel: viewModel)
                    DetailedRecipeInfo(viewModel: viewModel)
                    Spacer()
                }
            }
        }
        .onAppear {
                viewModel.fetchDetailedRecipe(recipeID: recipeID)
        }
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
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation {
                        if viewModel.detailedRecipe?.isSelected == false {
                            sharedViewModel.saveToFavorites(recipe: viewModel.detailedRecipe)
                        } else {
                            sharedViewModel.deleteFromFavorites(recipe: viewModel.detailedRecipe)
                        }
                        viewModel.detailedRecipe?.isSelected.toggle()
                        
                    }
                } label: {
                    if viewModel.detailedRecipe?.isSelected == false {
                        Image(systemName: "heart")
                            .tint(.yumPurple)
                    } else {
                        Image(systemName: "heart.fill")
                            .tint(.yumPurple)
                    }
                }
            }
        }
    }
}


struct DetailedRecipeImage: View {
    
    @ObservedObject var viewModel: DetailedRecipeViewModel
    
    var body: some View {
        AsyncImage(url: URL(string: viewModel.detailedRecipe?.image ?? "")) { result in
            switch result {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(20)
                    .outerShadowsStyle()
                    .padding(.horizontal)
            case .failure:
                Image(systemName: "xmark.circle")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(20)
                    .foregroundColor(.yumText)
                    .outerShadowsStyle()
                    .padding(.horizontal)
            @unknown default:
                EmptyView()
            }
        }
    }
}


struct DetailedRecipeName: View {
    
    @ObservedObject var viewModel: DetailedRecipeViewModel
    
    var body: some View {
        Text(viewModel.detailedRecipe?.title ?? "")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.system(size: 25))
            .fontWeight(.bold)
            .foregroundColor(.yumText)
            .padding(.horizontal)
    }
}


struct DetailedRecipeInfo: View {
    
    @ObservedObject var viewModel: DetailedRecipeViewModel
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "timer")
                    .foregroundColor(.yumPurple)
                Text("\(viewModel.detailedRecipe?.readyInMinutes ?? 0) minutes")
                    .foregroundColor(.yumText)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            Text("Ingredients:")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 20))
                .foregroundColor(.yumText)
                .lineLimit(1)
                .padding(.horizontal)
                .padding(.top, 15)
           
            ForEach(viewModel.detailedRecipe?.extendedIngredients ?? [], id: \.self) { ingredient in
                VStack {
                    HStack {
                        Image(systemName: "arrowtriangle.forward.fill")
                            .foregroundColor(.yumPurple)
                        Text(ingredient.original)
                            .foregroundColor(.yumText)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
            }
        }
    }
}
