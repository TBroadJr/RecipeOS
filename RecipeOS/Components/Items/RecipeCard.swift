//
//  RecipeCard.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/28/22.
//

import SwiftUI

struct RecipeCard: View {
    
        // MARK: - Properties
    var recipe: Recipe
    var namespace: Namespace.ID
    
        // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            recipeImage
            VStack(alignment: .leading, spacing: 5) {
                recipeTitle
                recipeCookingItem
            }
            .padding()
        }
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
        .strokeStyle(cornerRadius: 30)
        .shadow(color: Color("Shadow").opacity(0.3), radius: 20, x: 0, y: 10)
    }
        
        // MARK: - Recipe Image
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
    }
    
        // MARK: - Recipe Title
    private var recipeTitle: some View {
        Text(recipe.unwrappedTitle)
            .font(.title.bold())
    }
    
        // MARK: - Recipe Cooking Item
    private var recipeCookingItem: some View {
        RecipeCookingItem(amountServed: recipe.servingsInt, cookingTime: recipe.cookingTimeInt)

    }
    
}


struct RecipeCard_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        RecipeCard(recipe: Recipe(), namespace: namespace)
    }
}
