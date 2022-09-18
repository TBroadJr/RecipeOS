//
//  RegisterView.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/17/22.
//

import SwiftUI

struct RegisterView: View {
    
        // MARK: - Properties
    @EnvironmentObject var manager: DataManager
    
        // MARK: - Body
    var body: some View {
        ZStack {
            background
        }
    }
        // MARK: - Background
    private var background: some View {
        Color.clear
            .background(.ultraThinMaterial)
            .ignoresSafeArea()
    }
    
        // MARK: - Display
    private var display: some View {
        Group {
            switch
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
            .environmentObject(DataManager())
    }
}
