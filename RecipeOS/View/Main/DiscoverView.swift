//
//  DiscoverView.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/19/22.
//

import SwiftUI

struct DiscoverView: View {
    
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
        .statusBar(hidden: !showStatusBar)
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
    
        // MARK: - Screen Background
    private var screenBackground: some View {
        Color("Background")
            .ignoresSafeArea()
    }
    
        // MARK: - Scroll View
    private var scrollView: some View {
        ScrollView {
            scrollDetection
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 300), spacing: 20)], spacing: 20) {
                if !show {
                    recipeCards
                } else {
                    ForEach(recipes) { recipe in
                        Rectangle()
                            .fill(.white)
                            .frame(height: 300)
                            .cornerRadius(30)
                            .shadow(color: Color("Shadow"), radius: 20, x: 0, y: 10)
                            .opacity(0.3)
                        .padding(.horizontal, 30)
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .coordinateSpace(name: "scroll")
        .safeAreaInset(edge: .top, content: {
            Color.clear.frame(height: 70)
        })
        .overlay(overlay)
    }
    
        // MARK: - Scroll Detection
    private var scrollDetection: some View {
        GeometryReader { geo in
            Color.clear.preference(key: ScrollPreferenceKey.self, value: geo.frame(in: .named("scroll")).minY)
        }
        .frame(height: 0)
        .onPreferenceChange(ScrollPreferenceKey.self) { newValue in
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
    private var overlay: some View {
        NavigationBar(hasScrolled: $hasScroll, title: "Discover")
    }
    
        // MARK: - Recipe Cards
    private var recipeCards: some View {
        ForEach(recipes) { recipe in
            RecipeCard(recipe: recipe, namespace: namespace)
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
    
        // MARK: - Recipe Detail
    private var recipeDetail: some View {
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

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
            .environmentObject(DataManager())
    }
}
