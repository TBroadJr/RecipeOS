//
//  FavoriteView.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/19/22.
//

import SwiftUI

struct FavoriteView: View {
    
    // MARK: - Properties
    @EnvironmentObject var manager: DataManager
    @FetchRequest(sortDescriptors: []) var recipes: FetchedResults<Recipe>
    @Namespace var namespace
    @State private var hasScroll = false
    @State private var show = false
    @State private var showStatusBar = false
    @State private var selectedID = UUID()
    
    // MARK: - Body
    var body: some View {
        ZStack {
            screenBackground
            scrollView
            if show {
                recipeDetail
            }
        }
    }
}

// MARK: - FavoriteView Extension
private extension FavoriteView {
    
    // MARK: - Screen Background
    var screenBackground: some View {
        Color("Background").ignoresSafeArea()
        
    }
    
    // MARK: - Scroll View
    var scrollView: some View {
        ScrollView {
            scrollDetection
            favoriteText
            favoriteSection
            createdText
            createdSection
        }
        .coordinateSpace(name: "Scroll2")
        .safeAreaInset(edge: .top) {
            Color.clear.frame(height: 70)
        }
       .overlay(navigationBarOverlay)
       .statusBarHidden(!showStatusBar)
       .onChange(of: show) { newValue in
           withAnimation(.closeCard) {
               if newValue {
                   showStatusBar = false
               } else {
                   showStatusBar = true
               }
           }
       }
    }
    
    // MARK: - Favorite Text
    var favoriteText: some View {
        Text("Favorited".uppercased())
            .headlineText()
    }
    
    // MARK: - Created Text
    var createdText: some View {
        Text("Created".uppercased())
            .headlineText()
    }
    
    // MARK: - Favorite Section
    var favoriteSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(recipes) { recipe in
                    if recipe.isFavorited {
                        RecipeCard(recipe: recipe, namespace: namespace)
                            .frame(width: 300, height: 300)
                            .shadow(color: Color("Shadow").opacity(0.3), radius: 5, x: 0, y: 10)
                            .padding()
                            .onTapGesture {
                                withAnimation(.openCard) {
                                    show.toggle()
                                    manager.showDetail.toggle()
                                    showStatusBar = false
                                    selectedID = recipe.unwrappedID
                                }
                            }
                    }
                }
                .padding(.horizontal, 5)
            }
        }
        .frame(height: UIScreen.main.bounds.height / 3)
    }
    
    // MARK: - Created Section
    var createdSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(recipes) { recipe in
                    if recipe.isCreated {
                        RecipeCard(recipe: recipe, namespace: namespace)
                            .frame(width: 300, height: 300)
                            .shadow(color: Color("Shadow").opacity(0.3), radius: 5, x: 0, y: 10)
                            .padding()
                            .onTapGesture {
                                withAnimation(.openCard) {
                                    show.toggle()
                                    manager.showDetail.toggle()
                                    showStatusBar = false
                                    selectedID = recipe.unwrappedID
                                }
                            }
                    }
                }
                .padding(.horizontal, 5)
            }
        }
        .frame(height: UIScreen.main.bounds.height / 3)
    }
    
    // MARK: - Scroll Detection
    var scrollDetection: some View {
        GeometryReader { geo in
            Color.clear.preference(key: ScrollPreferenceKey2.self, value: geo.frame(in: .named("Scroll2")).minY)
        }
        .frame(height: 0)
        .onPreferenceChange(ScrollPreferenceKey2.self) { newValue in
            withAnimation(.easeInOut) {
                if newValue < 0 {
                    hasScroll = true
                } else {
                    hasScroll = false
                }
            }
        }
    }
    
    // MARK: - Overlay
    var navigationBarOverlay: some View {
        NavigationBar(hasScrolled: $hasScroll, title: "Favorite")
    }
    
    // MARK: - Recipe Detail
    var recipeDetail: some View {
        ForEach(recipes) { recipe in
            if recipe.unwrappedID == selectedID {
                RecipeDetail(show: $show, namespace: namespace, recipe: recipe)
                    .zIndex(1)
                    .transition(.asymmetric(
                        insertion: .opacity.animation(.easeInOut(duration: 0.1)),
                        removal: .opacity.animation(.easeInOut(duration: 0.3).delay(0.2))))
            }
        }
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
            .environmentObject(DataManager())
    }
}
