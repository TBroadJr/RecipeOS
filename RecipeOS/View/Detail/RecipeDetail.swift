//
//  RecipeDetail.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/29/22.
//

import SwiftUI

struct RecipeDetail: View {
    
    // MARK: - Properties
    @EnvironmentObject var manager: DataManager
    @State private var viewState: CGSize = .zero
    @State private var isDraggable = true
    @State private var showSection = false
    @State private var selectedIndex = 0
    @State private var appear = [false, false, false]
    @Binding var show: Bool
    var namespace: Namespace.ID
    var recipe: Recipe
    
    
    var body: some View {
        ZStack {
            scrollView
            xmarkButton
        }
        .safeAreaInset(edge: .top, content: {
            Color.clear.frame(height: 5)
        })
        .onAppear {
            fadeIn()
        }
        .onChange(of: show) { newValue in
            fadeOut()
        }
    }
    
        // MARK: - Background
    private var background: some View {
        Color("Background").ignoresSafeArea()
    }
    
        // MARK: - Scroll View
    private var scrollView: some View {
        ScrollView {
            recipeImage
            recipeInfo
            ingredientsTitle
            ingredients
        }
        .onAppear { manager.showDetail = true }
        .onDisappear { manager.showDetail = false }
        .background(background)
        .shadow(color: Color("Shadow").opacity(0.3), radius: 30, x: 0, y: 10)
        .background(.ultraThinMaterial)
    }
    
        // MARK: - Cover
    private var recipeImage: some View {
        ImageLoader(url: recipe.unwrappedImageURL) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
            case .failure(_):
                Color.gray
            @unknown default:
                EmptyView()
            }
        }
        .strokeStyle(cornerRadius: 30)
        .matchedGeometryEffect(id: "image\(recipe.unwrappedID)", in: namespace)
        .padding(.horizontal, 20)
    }
    
        // MARK: - Recipe Info
    private var recipeInfo: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(recipe.unwrappedTitle)
                .font(.title.bold())
                .frame(maxWidth: .infinity, alignment: .leading)
            RecipeCookingItem(amountServed: recipe.servingsInt, cookingTime: recipe.cookingTimeInt)
            Divider()
            Link(destination: recipe.unwrappedSourceURL) {
                HStack {
                    Label("Recipe", systemImage: "book")
                    Spacer()
                    Image(systemName: "link")
                        .foregroundColor(.secondary)
                }
                .accentColor(.primary)
            }
        }
        .padding(20)
        .background {
            Rectangle()
                .fill(.ultraThinMaterial)
                .mask {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                }
        }
        .strokeStyle(cornerRadius: 30)
        .padding(20)
        .opacity(appear[0] ? 1 : 0)
    }
    
        // MARK: - Ingredients Title
    private var ingredientsTitle: some View {
        Text("Ingredients".uppercased())
            .font(.footnote.weight(.semibold))
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .opacity(appear[1] ? 1 : 0)
    }
    
        // MARK: - Ingredients
    private var ingredients: some View {
        VStack(spacing: 10) {
            ForEach(recipe.unwrappedIngredients, id: \.self) { ingredient in
                Text(ingredient)
                    .font(.headline.weight(.medium))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
        .strokeStyle(cornerRadius: 30)
        .padding(20)
        .opacity(appear[2] ? 1 : 0)
    }
    
        // MARK: - Xmark Button
    private var xmarkButton: some View {
        Button {
            withAnimation(.closeCard) {
                show.toggle()
                manager.showDetail.toggle()
            }
        } label: {
            Image(systemName: "xmark")
                .font(.body.bold())
                .foregroundColor(.secondary)
                .padding(8)
                .background(.ultraThinMaterial, in: Circle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .padding(20)
        .ignoresSafeArea()
        .opacity(appear[2] ? 1 : 0)
    }
    
        // MARK: - Fade In Function
    private func fadeIn() {
        withAnimation(.easeOut.delay(0.3)) {
            appear[0] = true
        }
        withAnimation(.easeOut.delay(0.4)) {
            appear[1] = true
        }
        withAnimation(.easeOut.delay(0.5)) {
            appear[2] = true
        }
    }
    
        // MARK: - Fade Out Function
    private func fadeOut() {
        appear[0] = false
        appear[1] = false
        appear[2] = false
    }
}

struct RecipeDetail_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        Group {
            RecipeDetail(show: .constant(true), namespace: namespace, recipe: Recipe())
                .environmentObject(DataManager())
            RecipeDetail(show: .constant(true), namespace: namespace, recipe: Recipe())
                .preferredColorScheme(.dark)
                .environmentObject(DataManager())
        }
    }
}
