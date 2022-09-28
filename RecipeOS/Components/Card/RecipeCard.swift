//
//  RecipeCard.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/28/22.
//

import SwiftUI

struct RecipeCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            recipeImage
            VStack(alignment: .leading, spacing: 5) {
                recipeTitle
                RecipeCookingView()
            }
            .padding()
            .padding(.bottom, 12)
        }
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
    
        // MARK: - Recipe Image
    private var recipeImage: some View {
        ImageLoader(url: URL(string: "https://spoonacular.com/recipeImages/638257-556x370.jpg")!)
            .scaledToFit()
    }
    
        // MARK: - Recipe Title
    private var recipeTitle: some View {
        Text("Fried Chicken")
            .font(.title.bold())
    }
}

struct RecipeCookingView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            servings
            time
        }
        .font(.footnote)
        .foregroundColor(.secondary)
    }
    
        // MARK: - Serving
    private var servings: some View {
        HStack(alignment: .center, spacing: 2) {
            Image(systemName: "person.2")
            Text("Serves: 4")
        }
    }
    
        // MARK: - Time
    private var time: some View {
        HStack(alignment: .center, spacing: 2) {
            Image(systemName: "clock")
            Text("Time: 40 min")
        }
    }
}

struct RecipeCard_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCard()
    }
}
