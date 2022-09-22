//
//  Recipe.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/22/22.
//

import Foundation

struct RecipeInfo: Codable {
    var hits: [Hits]
}

struct Hits: Codable {
    var recipe: Recipe
}

struct Recipe: Codable {
    var label: String
    var images: RecipeImage
    var url: URL
    var ingredientLines: [String]
    var calories: Double
    var totalTime: Double
}
struct RecipeImage: Codable {
    var thumbnail: ImageInfo
    var small: ImageInfo
    var regular: ImageInfo
    
    enum CodingKeys: String, CodingKey {
        case thumbnail = "THUMBNAIL"
        case small = "SMALL"
        case regular = "REGULAR"
    }
}

struct ImageInfo: Codable {
    var url: URL
}
