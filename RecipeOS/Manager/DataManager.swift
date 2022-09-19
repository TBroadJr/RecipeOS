//
//  DataManager.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/17/22.
//

import Foundation

class DataManager: ObservableObject {
    @Published var registerType: RegisterType = .signIn
    @Published var selectedTab: Tab = .discover
}
