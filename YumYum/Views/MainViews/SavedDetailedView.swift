//
//  SavedDetailedView.swift
//  YumYum
//
//  Created by Kamil Biktineyev on 31.07.2024.
//

import SwiftUI

// Экран с детальным описанием рецепта из сохраненного списка рецептов
struct SavedDetailedView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var sharedViewModel: SharedViewModel
    
    let recipeID: Int
    let recipeTitle: String
    let recipeImage: String
    let readyInMinutes: Int
    let extendedIngredients: [CleanIngredients]
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                ScrollView(showsIndicators: false) {
                    SavedRecipeImage(image: recipeImage)
                    SavedRecipeName(title: recipeTitle)
                    SavedRecipeInfo(readyInMinutes: readyInMinutes, ingredients: extendedIngredients)
                    Spacer()
                }
            }
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
                        sharedViewModel.deleteFromFavoritesWithID(recipeID: recipeID)
                        presentationMode.wrappedValue.dismiss()
                    }
                } label: {
                    Text("Delete recipe")
                        .tint(.yumPurple)
                }
            }
        }
    }
}

struct SavedRecipeImage: View {
    
    let image: String
    
    var body: some View {
        AsyncImage(url: URL(string: image)) { result in
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


struct SavedRecipeName: View {
    
    let title: String
    
    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.system(size: 25))
            .fontWeight(.bold)
            .foregroundColor(.yumText)
            .padding(.horizontal)
    }
}


struct SavedRecipeInfo: View {
    
    let readyInMinutes: Int
    let ingredients: [CleanIngredients]
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "timer")
                    .foregroundColor(.yumPurple)
                Text("\(readyInMinutes) minutes")
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
           
            ForEach(ingredients, id: \.self) { ingredient in
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
