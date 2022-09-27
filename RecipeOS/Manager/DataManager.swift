//
//  DataManager.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/17/22.
//

import Foundation
import CoreData

class DataManager: ObservableObject {
    @Published var registerType: RegisterType = .signIn
    
    let container = NSPersistentContainer(name: "RecipeModel")
    
    init() {
        container.loadPersistentStores { description, error in
            print(description)
        }
        
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
    
        // MARK: - Recipe API Request
    func fetchRecipe() async {
        guard let url = URL(string: "https://api.edamam.com/api/recipes/v2?type=public&q=chicken&app_id=d692ee4d&app_key=%208d01605663aed27356a82231a49dbd04") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let recipeData = try JSONDecoder().decode(RecipeInfo.self, from: data)
            addToCoreData(recipeInfo: recipeData)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
        // MARK: - Add To Core Data
    private func addToCoreData(recipeInfo: RecipeInfo) {
        for recipe in recipeInfo.hits {
            let newRecipe = Recipe(context: container.viewContext)
            newRecipe.label = recipe.recipe.label
            newRecipe.calories = recipe.recipe.calories
            newRecipe.cookingTime = recipe.recipe.totalTime
            newRecipe.sourceURL = recipe.recipe.url
            newRecipe.image = recipe.recipe.images.regular.url
            newRecipe.id = UUID()
            
            let joinedIngredients = recipe.recipe.ingredientLines.joined(separator: "$")
            newRecipe.ingredients = joinedIngredients
        }
        try? container.viewContext.save()
    }
    
}
