//
//  SearchRecipesView.swift
//  YumYum
//
//  Created by Kamil Biktineyev on 27.07.2024.
//

import SwiftUI

// Экран поиска конкретного рецепта
struct SearchRecipesView: View {
    
    @State private var searchText: String = ""
    @State private var searchItems: [MealAutocomplete] = []
    
    @Binding var isSearching: Bool
    
    @StateObject private var viewModel = SearchRecipesViewModel()
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                BackgroundView()
                
                VStack {
                    SearchBar(searchText: $searchText, isSearching: $isSearching, viewModel: viewModel)
                        .padding(.top, 10)
                    SearchItems(searchText: $searchText, searchItems: $searchItems, viewModel: viewModel)
                        .animation(.easeInOut(duration: 0.5), value: searchItems)
                    Spacer()
                }
                .onReceive(viewModel.$searchItems) { newValue in
                    self.searchItems = newValue
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation {
                            isSearching = false
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


struct SearchBar: View {
    
    @State private var searchResultsIsPresented: Bool = false
    
    @Binding var searchText: String
    @Binding var isSearching: Bool
    
    @FocusState private var isFocused: Bool
    
    @ObservedObject var viewModel: SearchRecipesViewModel
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .frame(width: 20 ,height: 20)
                .tint(.yumText)
                .outerShadowsStyle()
            TextField("Search a recipe", text: $searchText)
                .frame(height: 20)
                .innerShadowsStyle()
                .focused($isFocused)
                .keyboardType(.default)
                .submitLabel(.search)
                .onChange(of: searchText) { _, newValue in
                    if newValue.count > 1 {
                        viewModel.fetchMealAutocomplete(searchingMeal: searchText.lowercased())
                    }
                }
                .onSubmit {
                    searchResultsIsPresented = true
                }
        }
        .navigationDestination(isPresented: $searchResultsIsPresented, destination: {
            SearchResultsView(searchingRecipe: searchText)
        })
        .padding(.horizontal)
        .onAppear {
            isFocused = true
        }
    }
}


struct SearchItems: View {
    
    @State private var isSearchItemsVisible = false
    
    @Binding var searchText: String
    @Binding var searchItems: [MealAutocomplete]
    
    @ObservedObject var viewModel: SearchRecipesViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            if isSearchItemsVisible {
                HStack(alignment: .center) {
                    ForEach(searchItems, id: \.self) { item in
                        NavigationLink(destination: SearchResultsView(searchingRecipe: item.title)) {
                            Text(item.title)
                                .padding(5)
                                .background(.yumPurple)
                                .foregroundColor(.yumBackground)
                                .cornerRadius(10)
                                .padding(3)
                                .transition(.scale)
                        }
                    }
                }
            }
        }
        .frame(height: 40)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    isSearchItemsVisible = true
                }
            }
        }
    }
}
