//
//  DataManager.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/17/22.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseCore
import Firebase
import CoreData

class DataManager: ObservableObject {
    @Published var registerType: RegisterType = .signIn
    @Published var showDetail = false
    
    let container = NSPersistentContainer(name: "RecipeModel")
    let db = Firestore.firestore()
    
    init() {
        container.loadPersistentStores { description, error in
            print(description)
        }
        
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
    
    // MARK: - Recipe API Request
    func fetchRecipeAPI() async {
        guard let url = URL(string: "https://api.spoonacular.com/recipes/random?apiKey=043de4e4b414423d84ec295540e8d111&number=20") else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let recipeData = try JSONDecoder().decode(RecipeData.self, from: data)
            addToServer(recipeData: recipeData)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Add recipe to server
    func addToServer(recipeData: RecipeData) {
        var recipes = [DatabaseRecipe]()
        for recipe in recipeData.recipes {
            var ingredients = [String]()
            for i in recipe.extendedIngredients {
                ingredients.append(i.original)
            }
            let newRecipe = DatabaseRecipe(
                title: recipe.title,
                imageData: nil,
                ingredients: ingredients,
                instructions: [],
                servings: recipe.servings,
                cookingTime: recipe.readyInMinutes,
                isCreated: false,
                isFavorited: false,
                id: UUID(),
                sourceURL: recipe.spoonacularSourceUrl,
                imageURL: recipe.image
            )
            recipes.append(newRecipe)
        }
        let item = RecipeDataArray(recipeData: recipes)
        
        do {
            try db.collection("App Data").document("Recipe Data").setData(from: item, merge: true)
        } catch {
            print("Adding To Firebase Error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Retrieve Recipes from server
    func getRecipeServer() async {
        let docRef = db.collection("App Data").document("Recipe Data")
        
        docRef.getDocument(as: RecipeDataArray.self) { [unowned self] result in
            switch result {
            case .success(let recipeData):
                self.addToCoreData(recipeData: recipeData)
            case .failure(let failure):
                print("Retrieving data failure: \(failure.localizedDescription)")
            }
        }
    }
    
    // MARK: - Add Server Recipe To CoreData
    func addToCoreData(recipeData: RecipeDataArray) {
        for recipe in recipeData.recipeData {
            let newRecipe = Recipe(context: container.viewContext)
            newRecipe.title = recipe.title
            newRecipe.imageData = recipe.imageData
            newRecipe.servings = Int16(recipe.servings)
            newRecipe.cookingTime = Int16(recipe.cookingTime)
            newRecipe.isCreated = recipe.isCreated
            newRecipe.isFavorited = recipe.isFavorited
            newRecipe.id = recipe.id
            newRecipe.sourceURL = recipe.sourceURL
            newRecipe.imageURL = recipe.imageURL
            
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
    
    // MARK: - Add Created Recipe to core data
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
