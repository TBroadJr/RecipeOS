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


struct CreatedRecipe: Codable {
    var title: String
    var recipeImage: Data
    var ingredients: [String]
    var instructions: [String]
    var servings: Int
    var cookingTime: Int
}

struct DatabaseRecipe: Codable {
    var title: String
    var imageData: Data?
    var ingredients: [String]
    var instructions: [String]
    var servings: Int
    var cookingTime: Int
    var isCreated: Bool
    var isFavorited: Bool
    var id: UUID
    var sourceURL: URL?
    var imageURL: URL?
}

struct RecipeDataArray: Codable {
    var recipeData: [DatabaseRecipe]
}
