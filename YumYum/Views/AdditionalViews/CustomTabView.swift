//
//  CustomTabView.swift
//  YumYum
//
//  Created by Kamil Biktineyev on 24.07.2024.
//

import SwiftUI

struct CustomTabView: View {
    
    @StateObject var sharedViewModel = SharedViewModel()
    
    @State private var tabSelection: Int = 0

    let tabs = [
        TabItem(title: "Recipes", icon: "list.bullet.rectangle.portrait", tappedIcon: "list.bullet.rectangle.portrait.fill"),
        TabItem(title: "Favorites", icon: "heart", tappedIcon: "heart.fill"),
        TabItem(title: "Profile", icon: "person", tappedIcon: "person.fill")
    ]
    
    var body: some View {
        
        TabView(selection: $tabSelection) {
            RecipesView()
                .tag(0)
            FavoritesView()
                .tag(1)
            ProfileView()
                .tag(2)
        }
        .environmentObject(sharedViewModel)
        .overlay(alignment: .bottom) {
            VStack {
                Spacer()
                CustomTabViewItems(tabSelection: $tabSelection, tabs: tabs)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.yumBackground)
       
    }
}


struct CustomTabViewItems: View {
    
    @Binding var tabSelection: Int
    
    let tabs: [TabItem]
    
    var body: some View {
        HStack {
            ForEach(tabs.indices, id: \.self) { index in
                Spacer()
                Button {
                    tabSelection = index
                } label: {
                    if index == tabSelection {
                        VStack {
                            Image(systemName: tabs[index].tappedIcon)
                            Text(tabs[index].title)
                                .font(.system(size: 12))
                            
                        }
                        .frame(width: 60, height: 40)
                        .tint(.yumPurple)
                        .layoutPriority(1)
                        .innerShadowsStyle()
                    } else {
                        VStack {
                            Image(systemName: tabs[index].icon)
                            Text(tabs[index].title)
                                .font(.system(size: 12))
                            
                        }
                        .frame(width: 60, height: 40)
                        .tint(.yumPurple)
                        .layoutPriority(1)
                        .outerShadowsStyle()
                    }
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}


//#Preview {
//    HomeView()
//}

