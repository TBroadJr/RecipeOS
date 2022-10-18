//
//  AccountView.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/14/22.
//

import SwiftUI
import Firebase

struct AccountView: View {
    
    // MARK: - Properties
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var manager: DataManager
    @AppStorage("isLogged") var isLogged = true
    @AppStorage("isLiteMode") var isLiteMode = false

    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                profile
                menu
                signOutButton
            }
            .navigationTitle("Account")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                    }
                }
            }
        }
    }
}

// MARK: - AccountView Extension
private extension AccountView {
    
    // MARK: - Profile
    private var profile: some View {
        VStack(spacing: 8) {
            Image(systemName: "person.crop.circle.fill.badge.checkmark")
                .font(.title.weight(.semibold))
                .symbolRenderingMode(.palette)
                .foregroundStyle(.blue, .blue.opacity(0.3))
                .padding()
                .background(Circle().fill(.ultraThinMaterial))
                .background(BlobView().offset(x: 200).scaleEffect(0.6))
            Text("Tornelius Broadwater, Jr")
                .font(.title.weight(.semibold))
                .multilineTextAlignment(.center)
            
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    // MARK: - Menu
    private var menu: some View {
        Section {
            NavigationLink { FavoriteView() } label: {
                Label("Settings", systemImage: "gear")
            }
        }
        .accentColor(.primary)
        .listRowSeparatorTint(.blue)
        .listRowSeparator(.hidden)
    }
    
    // MARK: - Sign Out Button
    private var signOutButton: some View {
        Button {
            signOut()
        } label: {
            Text("Sign Out")
                .font(.headline.weight(.semibold))
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

// MARK: - AccountView Functions Extension
private extension AccountView {
    
    // MARK: - Sign Out Function
    private func signOut() {
        try? Auth.auth().signOut()
        isLogged = false
        isLiteMode = false
        dismiss()
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(DataManager())
    }
}
