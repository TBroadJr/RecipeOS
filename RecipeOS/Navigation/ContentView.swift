//
//  ContentView.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/14/22.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    @AppStorage("selectedTab") var selectedTab: Tab = .discover
    @AppStorage("showRegister") var showRegister = false
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var recipes: FetchedResults<Recipe>

    
    // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottom) {
            switch selectedTab {
            case .discover: DiscoverView()
            case .create: CreateView()
            case .favorite: FavoriteView()
            }
            
            TabBar()
                .offset(y: showRegister ? 200 : 0)
                .offset(y: manager.showDetail ? 200 : 0)
            
            if showRegister {
                RegisterView()
                    .zIndex(1)
            }
        }
        .statusBarHidden(true)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Color.clear
                .frame(height: 88)
        }
        .dynamicTypeSize(.large ... .xxLarge)
        .task {
            await getData()
        }
    }
}

// MARK: - ContentView Functions Extension
private extension ContentView {
    
    // MARK: - Get Data
    func getData() async {
        if recipes.isEmpty {
            await manager.getRecipeServer()
            if recipes.isEmpty {
                await manager.fetchRecipeAPI()
                await manager.getRecipeServer()
                print(recipes.count)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DataManager())
    }
}
