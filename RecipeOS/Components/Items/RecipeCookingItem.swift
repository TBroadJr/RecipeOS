//
//  RecipeCookingItem.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/29/22.
//

import SwiftUI

struct RecipeCookingItem: View {
    
    // MARK: - Properties
    var amountServed: Int
    var cookingTime: Int
    
    // MARK: - Body
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            servings
            time
        }
        .font(.footnote)
        .foregroundColor(.secondary)
    }
}

// MARK: - RecipeCookingItem Extension
private extension RecipeCookingItem {
    
    // MARK: - Serving
    private var servings: some View {
        HStack(alignment: .center, spacing: 2) {
            Image(systemName: "person.2")
            Text("Serves: \(amountServed)")
        }
    }
    
    // MARK: - Time
    private var time: some View {
        HStack(alignment: .center, spacing: 2) {
            Image(systemName: "clock")
            Text("Time: \(cookingTime) min")
        }
    }
}

struct RecipeCookingItem_Previews: PreviewProvider {
    static var previews: some View {
        RecipeCookingItem(amountServed: 5, cookingTime: 5)
    }
}
