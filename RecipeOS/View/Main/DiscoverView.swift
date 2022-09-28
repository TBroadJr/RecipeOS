//
//  DiscoverView.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/19/22.
//

import SwiftUI

struct DiscoverView: View {
    @State private var hasScroll = false
    var body: some View {
        ZStack {
            screenBackground
            scrollView
            
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
            recipeCards
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
        ForEach(0..<10) { item in
            RecipeCard()
                .padding(20)
        }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
