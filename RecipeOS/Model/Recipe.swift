//
//  Recipe.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/22/22.
//

import Foundation

struct RecipeData: Codable {
    var recipes: [RecipeInfo]
}

struct RecipeInfo: Codable {
    var extendedIngredients: [ExtendedIngredients]
    var title: String
    var readyInMinutes: Int
    var servings: Int
    var image: URL
    var spoonacularSourceUrl: URL
}

struct ExtendedIngredients: Codable {
    var original: String
}

