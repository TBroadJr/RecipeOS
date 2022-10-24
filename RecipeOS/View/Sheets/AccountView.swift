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
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject var manager: DataManager
    @AppStorage("isLogged") var isLogged = true
    @AppStorage("isLiteMode") var isLiteMode = false
    @AppStorage("showRegister") var showRegister = false
    @FetchRequest(sortDescriptors: []) var recipes: FetchedResults<Recipe>
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    var userName: String {
        Auth.auth().currentUser?.displayName ?? "firstName lastName"
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                profile
                menu
                Section {
                    signOutButton
                }
                Section {
                    deleteAccountButton
                }
            }
            .navigationTitle("Account")
            .statusBarHidden(true)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                    }
                }
//                ToolbarItemGroup(placement: .navigationBarLeading) {
//                    Button {
//                        deleteRecipes()
//                    } label: {
//                        Text("Reset")
//                    }
//                }
            }
            .alert(alertTitle, isPresented: $showAlert) {
                Button("Dismiss", role: .cancel) { signOut() }
            } message: {
                Text(alertMessage)
            }
        }
    }
}

// MARK: - AccountView Extension
private extension AccountView {
    
    // MARK: - Profile
    var profile: some View {
        VStack(spacing: 8) {
            Image(systemName: "person.crop.circle.fill.badge.checkmark")
                .font(.title.weight(.semibold))
                .symbolRenderingMode(.palette)
                .foregroundStyle(.blue, .blue.opacity(0.3))
                .padding()
                .background(Circle().fill(.ultraThinMaterial))
                .background(BlobView().offset(x: 200).scaleEffect(0.6))
            Text(userName)
                .font(.title.weight(.semibold))
                .multilineTextAlignment(.center)
            
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    // MARK: - Menu
    var menu: some View {
        Section {
            NavigationLink { SettingsView() } label: {
                Label("Settings", systemImage: "gear")
            }
        }
        .accentColor(.primary)
        .listRowSeparatorTint(.blue)
        .listRowSeparator(.hidden)
    }
    
    // MARK: - Sign Out Button
    var signOutButton: some View {
        Button {
            signOut()
        } label: {
            Text("Sign Out")
                .font(.headline.weight(.semibold))
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
    
    // MARK: - Delete Account Button
    var deleteAccountButton: some View {
        Button {
            deleteAccount()
        } label: {
            Text("Delete Account")
                .font(.headline.weight(.semibold))
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}

// MARK: - AccountView Functions Extension
private extension AccountView {
    
    // MARK: - Sign Out Function
    func signOut() {
        try? Auth.auth().signOut()
        isLogged = false
        isLiteMode = false
        dismiss()
    }
    
    // MARK: - Delete Account Button
    func deleteAccount() {
        guard let user = Auth.auth().currentUser else { return }
        user.delete { error in
            if let error = error {
                manager.registerType = .reauthenticate
                showRegister = true
                dismiss()
                print("Error \(error.localizedDescription)")
            } else {
                alertTitle = "Success"
                alertMessage = "Account deleted"
                showAlert = true
            }
        }
    }
    
    // MARK: - Delete Recipes
    func deleteRecipes() {
        for recipe in recipes {
            moc.delete(recipe)
            try? moc.save()
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(DataManager())
    }
}
