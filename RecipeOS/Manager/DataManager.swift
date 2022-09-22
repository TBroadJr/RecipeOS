//
//  DataManager.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/17/22.
//

import Foundation

class DataManager: ObservableObject {
    @Published var registerType: RegisterType = .signIn
    
        // MARK: - Recipe API Request
    func fetchRecipe() async {
        guard let url = URL(string: "https://api.edamam.com/api/recipes/v2?type=public&q=chicken&app_id=d692ee4d&app_key=%208d01605663aed27356a82231a49dbd04") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let response = String(data: data, encoding: .utf8) else { return }
            print(response)
        } catch {
            print("Error")
        }
                
                
    }
}
