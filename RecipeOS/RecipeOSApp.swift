//
//  RecipeOSApp.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/14/22.
//

import SwiftUI
import Firebase

@main
struct RecipeOSApp: App {
    @StateObject private var manager = DataManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
          ContentView()
                .environmentObject(manager).environment(\.managedObjectContext, manager.container.viewContext)
        }
    }
}
