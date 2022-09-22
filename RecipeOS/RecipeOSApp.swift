//
//  RecipeOSApp.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/14/22.
//

import SwiftUI

@main
struct RecipeOSApp: App {
    @StateObject private var manager = DataManager()
    var body: some Scene {
        WindowGroup {
          ContentView()
                .environmentObject(manager).environment(\.managedObjectContext, manager.container.viewContext)
        }
    }
}
