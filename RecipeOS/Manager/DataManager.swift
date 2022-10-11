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
    @Published var showDetail = false
    
    let container = NSPersistentContainer(name: "RecipeModel")
    
    init() {
        container.loadPersistentStores { description, error in
            print(description)
        }
        
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
    
        // MARK: - Recipe API Request
    func fetchRecipe() async {
        guard let url = URL(string: "https://api.spoonacular.com/recipes/random?apiKey=043de4e4b414423d84ec295540e8d111&number=10") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let recipeData = try JSONDecoder().decode(RecipeData.self, from: data)
            addToCoreData(recipes: recipeData)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
        // MARK: - Add to core data
    func addToCoreData(recipes: RecipeData) {
        for recipe in recipes.recipes {
            let newRecipe = Recipe(context: container.viewContext)
            newRecipe.title = recipe.title
            newRecipe.id = UUID()
            newRecipe.cookingTime = Int16(recipe.readyInMinutes)
            newRecipe.imageURL = recipe.image
            newRecipe.servings = Int16(recipe.servings)
            newRecipe.sourceURL = recipe.spoonacularSourceUrl
            newRecipe.isCreated = false
            
            var ingredients = [String]()
            for i in recipe.extendedIngredients {
                ingredients.append(i.original)
            }
            newRecipe.ingredients = ingredients.joined(separator: "$")
        }
        try? container.viewContext.save()
    }
    
    func addCreatedToCoreData(recipe: CreatedRecipe) {
        let newRecipe = Recipe(context: container.viewContext)
        newRecipe.title = recipe.title
        newRecipe.id = UUID()
        newRecipe.cookingTime = Int16(recipe.cookingTime)
        newRecipe.imageData = recipe.recipeImage
        newRecipe.servings = Int16(recipe.servings)
        newRecipe.isCreated = true
        
        var ingredients = [String]()
        for i in recipe.ingredients {
            ingredients.append(i)
        }
        newRecipe.ingredients = ingredients.joined(separator: "$")
        
        var instructions = [String]()
        for i in recipe.instructions {
            instructions.append(i)
        }
        newRecipe.instructions = instructions.joined(separator: "$")
        try? container.viewContext.save()
    }
}
