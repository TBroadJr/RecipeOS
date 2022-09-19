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
        
        // MARK: - Body
    var body: some View {
        ZStack(alignment: .bottom) {
            switch selectedTab {
            case .discover: DiscoverView()
            case .create: CreateView()
            case .plan: PlanView()
            case .favorite: FavoriteView()
            }
            
            TabBar()
                .offset(y: showRegister ? 200 : 0)
            
            if showRegister {
                RegisterView()
            }
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Color.clear
                .frame(height: 88)
        }
        .dynamicTypeSize(.large ... .xxLarge)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DataManager())
    }
}
