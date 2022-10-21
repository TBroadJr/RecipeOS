//
//  PlanView.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/19/22.
//

import SwiftUI

struct PlanView: View {
    
    // MARK: - Properties
    @State private var showRecipeSelection = false
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                background
                recipePlanList
            }
            .navigationTitle("Plan Recipes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    addButton
                }
            }
            .sheet(isPresented: $showRecipeSelection) {
                RecipeSelectionView()
            }
        }
    }
}

// MARK: - PlanView Extension
private extension PlanView {
    
    // MARK: - Background
    var background: some View {
        Color("Background").ignoresSafeArea()
    }
    
    // MARK: - Recipe Plan List
    var recipePlanList: some View {
        List {
            Text("Hello")
        }
    }
    
    // MARK: - Add Button
    var addButton: some View {
        Button {
           showRecipeSelection = true
        } label: {
            Image(systemName: "plus")
        }
    }
    
}

struct PlanView_Previews: PreviewProvider {
    static var previews: some View {
        PlanView()
    }
}
