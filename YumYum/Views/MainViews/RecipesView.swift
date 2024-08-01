//
//  RecipesView.swift
//  YumYum
//
//  Created by Kamil Biktineyev on 25.07.2024.
//

import SwiftUI

// Главный экран, где предлагается выбрать национальную кухню, рецепты которой вы хотите посмотреть
struct RecipesView: View {
    
    @State private var isSearching: Bool = false
    
    @StateObject private var viewModel = RecipesViewModel()
    
    private var cuisines: [Cuisine] = [
        Cuisine(id: 0, title: "Asian", image: "Asian"),
        Cuisine(id: 1, title: "American", image: "American"),
        Cuisine(id: 2, title: "British", image: "British"),
        Cuisine(id: 3, title: "Chinese", image: "Chinese"),
        Cuisine(id: 4, title: "European", image: "European"),
        Cuisine(id: 5, title: "French", image: "French"),
        Cuisine(id: 6, title: "Greek", image: "Greek"),
        Cuisine(id: 7, title: "Indian", image: "Indian"),
        Cuisine(id: 8, title: "Italian", image: "Italian"),
        Cuisine(id: 9, title: "Japanese", image: "Japanese"),
        Cuisine(id: 10, title: "Korean", image: "Korean"),
        Cuisine(id: 11, title: "Latin American", image: "LatinAmerican"),
        Cuisine(id: 12, title: "Mexican", image: "Mexican"),
        Cuisine(id: 13, title: "Spanish", image: "Spanish"),
        Cuisine(id: 14, title: "Thai", image: "Thai"),
        Cuisine(id: 15, title: "Vietnamese", image: "Vietnamese")
    ]
    
    var body: some View {
        
        ZStack {
            BackgroundView()
            
            VStack {
                SearchBarButton(isSearching: $isSearching)
                CuisineGrid(cuisines: cuisines, viewModel: viewModel)
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $isSearching) {
            SearchRecipesView(isSearching: $isSearching)
        }
    }
}


struct SearchBarButton: View {
    
    @Binding var isSearching: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .frame(width: 20 ,height: 20)
                .tint(.yumText)
                .outerShadowsStyle()
            Button {
                withAnimation {
                    isSearching = true
                }
            } label: {
                Text("Search a recipe")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(height: 20)
                    .foregroundColor(.gray)
                    .innerShadowsStyle()
            }
        }
        .padding(.horizontal)
    }
}


struct CuisineGrid: View {
    
    @State private var cuisineRecipeViewIsPresented: Bool = false
    
    var cuisines: [Cuisine]
   
    @ObservedObject var viewModel: RecipesViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(cuisines, id: \.self) { cuisine in
                    VStack {
                        Image(cuisine.image)
                            .resizable()
                            .frame(width: 140, height: 90)
                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(20)
                        Text(cuisine.title)
                            .font(.system(size: 14))
                            .foregroundColor(.yumText)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 110)
                    .outerShadowsStyle()
                    .padding(3)
                    .onTapGesture {
                        withAnimation {
                            viewModel.tappedCuisine = cuisine.title
                            cuisineRecipeViewIsPresented = true
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $cuisineRecipeViewIsPresented) {
            CuisineResipesView(cuisineRecipeViewIsPresented: $cuisineRecipeViewIsPresented, cuisine: viewModel.tappedCuisine ?? "")
        }
    }
}
