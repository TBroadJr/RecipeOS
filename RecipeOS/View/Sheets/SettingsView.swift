//
//  SettingsView.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 10/21/22.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    
    // MARK: - Properties
    @Environment(\.dismiss) var dismiss
    @State private var nameField = ""
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var completionResult: CompletionResult = .success
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                background
                form
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    updateButton
                }
            })
            .alert(alertTitle, isPresented: $showAlert) {
                switch completionResult {
                case .success:
                    Button("Dismiss", role: .cancel) { dismiss() }
                case .failure:
                    Button("Retry", role: .cancel) { nameField = "" }
                }
            } message: {
                Text(alertMessage)
            }
        }
    }
}

// MARK: - SettingsView Extension
private extension SettingsView {
    
    // MARK: - Background
    var background: some View {
        Color("Background").ignoresSafeArea()
    }
    
    // MARK: - Form
    var form: some View {
        Form {
            nameTextField
        }
    }
    
    // MARK: - Name Textfield
    var nameTextField: some View {
        TextField("Enter Name", text: $nameField)
    }
    
    // MARK: - Update Button
    var updateButton: some View {
        Button {
            updateInfo()
        } label: {
            Text("Update")
        }
    }
    
}

// MARK: - SettingsView Functions Extension
private extension SettingsView {
    
    // MARK: - Update User Info
    func updateInfo() {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = nameField
        changeRequest?.commitChanges(completion: { error in
            if let error = error {
                completionResult = .failure
                alertTitle = "Error"
                alertMessage = error.localizedDescription
                showAlert = true
            } else {
                completionResult = .success
                alertTitle = "Success"
                alertMessage = "Name Updated"
                showAlert = true
            }
        })
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
