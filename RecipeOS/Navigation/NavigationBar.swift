//
//  NavigationBar.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/14/22.
//

import SwiftUI

struct NavigationBar: View {
    
    // MARK: -  Properties
    @AppStorage("isLogged") var isLogged = false
    @AppStorage("showRegister") var showRegister = false
    @State private var showSearch = false
    @State private var showAccount = false
    @Binding var hasScrolled: Bool
    var title = ""
    
    // MARK: - Body
    var body: some View {
        ZStack {
            background
            titleText
            navigationButtons
        }
        .frame(height: hasScrolled ? 44 : 70)
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

// MARK: - NavigationBar Extension
private extension NavigationBar {
    
    // MARK: - Background
    private var background: some View {
        Color.clear
            .background(.ultraThinMaterial)
            .blur(radius: 10)
            .opacity(hasScrolled ? 1 : 0)
    }
    
    // MARK: - Title Text
    private var titleText: some View {
        Text(title)
            .animatableFont(size: hasScrolled ? 22 : 34, weight: .bold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)
            .padding(.leading, 20)
            .offset(y: hasScrolled ? -4 : 0)
    }
    
    // MARK: - Search Button
    private var searchButton: some View {
        Button {
            showSearch = true
        } label: {
            Image(systemName: "magnifyingglass")
                .font(.body.bold())
                .frame(width: 36, height: 36)
                .foregroundColor(.secondary)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
                .strokeStyle(cornerRadius: 14)
            
        }
        .sheet(isPresented: $showSearch) {
            SearchView()
        }
    }
    
    // MARK: - Account Button
    private var accountButton: some View {
        Button {
            if isLogged {
                withAnimation {
                    showAccount = true
                }
            } else {
                withAnimation {
                    showRegister = true
                }
            }
        } label: {
            Image("Avatar Default")
                .resizable()
                .frame(width: 26, height: 26)
                .cornerRadius(10)
                .padding(8)
                .background(
                    .ultraThinMaterial,
                    in: RoundedRectangle(cornerRadius: 18, style: .continuous)
                )
                .strokeStyle(cornerRadius: 18)
        }
        .sheet(isPresented: $showAccount) {
            AccountView()
        }
    }
    
    // MARK: - Navigation Buttons
    private var navigationButtons: some View {
        HStack(spacing: 16) {
            searchButton
            accountButton
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.top, 20)
        .padding(.trailing, 20)
        .offset(y: hasScrolled ? -4 : 0)
    }
}


struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(hasScrolled: .constant(false))
    }
}
