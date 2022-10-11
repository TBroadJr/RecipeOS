//
//  CreateView.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/19/22.
//

import SwiftUI

struct CreateView: View {
    
        // MARK: - Properties
    @EnvironmentObject var manager: DataManager
    
    @State private var showImagePicker = false
    @State private var recipeImage = UIImage(systemName: "photo")
    
    @State private var ingredients = [String]()
    @State private var instructions = [String]()
    
    @State private var recipeTitle = ""
    @State private var ingredientTextField = ""
    @State private var instructionsTextField = ""
    
    @State private var recipeServings = 0
    @State private var recipeCookingTime = 0
    
    @State private var showErrorAlert = false
    @State private var showCreateAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
        
        // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                imageSection
                infoSection
                ingredientSection
                instructionSection
            }
            .navigationTitle("Create Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                Color.clear
                    .frame(height: 88)
            }
            .toolbar(content: {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    resetButton
                }
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    createButton
                }
            })
            .sheet(isPresented: $showImagePicker) {
                PhotoPicker(recipeImage: $recipeImage)
            }
            .alert(alertTitle, isPresented: $showErrorAlert) {
                Button("Retry", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .alert(alertTitle, isPresented: $showCreateAlert) {
                Button("Continue", role: .cancel) { reset() }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
        // MARK: - Image Section
    private var imageSection: some View {
        Section("Add Image") {
            Image(uiImage: recipeImage!)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 150)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .center)
                .onTapGesture { showImagePicker = true }
        }
    }
    
        // MARK: - Info Section
    private var infoSection: some View {
        Section("Add Info") {
            TextField("Title", text: $recipeTitle)
            
            Picker("Servings", selection: $recipeServings) {
                ForEach(0..<11) {
                    Text("\($0)")
                }
            }
            
            Picker("Cooking Time", selection: $recipeCookingTime) {
                ForEach(0..<501) {
                    Text("\($0) min")
                }
            }
        }
    }
        
        // MARK: - Ingredient Section
    private var ingredientSection: some View {
        Section("Ingredients") {
            ForEach(ingredients, id: \.self) { item in
                Text(item)
            }
            .onDelete { indexSet in
                ingredients.remove(atOffsets: indexSet)
            }
            TextField("Ingredient", text: $ingredientTextField)
            Button {
                addIngredient()
            } label: {
                Text("Add Ingredient".uppercased())
            }
            .buttonStyle(.bordered)
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
        // MARK: - Instruction Section
    private var instructionSection: some View {
        Section("Instructions") {
            ForEach(instructions, id: \.self) { item in
                Text(item)
            }
            .onDelete { indexSet in
                instructions.remove(atOffsets: indexSet)
            }
            TextField("Instruction", text: $instructionsTextField)
            Button {
                addInstruction()
            } label: {
                Text("Add Instruction".uppercased())
            }
            .buttonStyle(.bordered)
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
        // MARK: - Reset Button
    private var resetButton: some View {
        Button {
            reset()
        } label: {
            Text("Reset")
        }
    }
    
        // MARK: - Create Button
    private var createButton: some View {
        Button {
            createRecipe()
        } label: {
            Text("Create")
        }
    }
    
        // MARK: - Reset
    private func reset() {
        recipeTitle = ""
        ingredientTextField = ""
        instructionsTextField = ""
        recipeServings = 0
        recipeCookingTime = 0
        ingredients.removeAll()
        instructions.removeAll()
    }
    
        // MARK: - Validate Ingredient
    private func isIngredientValid(item: String) -> Bool {
        guard !item.isEmpty else {
            alertTitle = "Ingredient Error"
            alertMessage = "Field is Empty"
            showErrorAlert = true
            ingredientTextField = ""
            return false
        }
        guard !ingredients.contains(item) else {
            alertTitle = "Ingredient Error"
            alertMessage = "Duplicate ingredients are not allowed"
            showErrorAlert = true
            ingredientTextField = ""

            return false
        }
        return true
    }
    
        // MARK: - Add Ingredient
    private func addIngredient() {
        let ingredientString = ingredientTextField.trimmingCharacters(in: .whitespacesAndNewlines)
        let uppercasedText = ingredientString.uppercased()
        guard isIngredientValid(item: uppercasedText) else { return }
        ingredients.append(uppercasedText)
        ingredientTextField = ""
    }
    
        // MARK: - Validate Instruction
    private func isInstructionValid(item: String) -> Bool {
        guard !item.isEmpty else {
            alertTitle = "Instruction Error"
            alertMessage = "Field is empty"
            showErrorAlert = true
            instructionsTextField = ""
            return false
        }
        return true
    }
    
        // MARK: - Add Instruction
    private func addInstruction() {
        let uppercasedText = instructionsTextField.uppercased()
        guard isInstructionValid(item: uppercasedText) else { return }
        instructions.append(uppercasedText)
        instructionsTextField = ""
    }
    
        // MARK: - Create Recipe
    private func createRecipe() {
        guard let imageData = recipeImage?.jpegData(compressionQuality: 1.0) else { return }
        let createdRecipe = CreatedRecipe(title: recipeTitle, recipeImage: imageData, ingredients: ingredients, instructions: instructions, servings: recipeServings, cookingTime: recipeCookingTime)
        manager.addCreatedToCoreData(recipe: createdRecipe)
        alertTitle = "Success"
        alertMessage = "Recipe Created!"
        showCreateAlert = true
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
            .environmentObject(DataManager())
    }
}
