//
//  ReauthenticateView.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 10/20/22.
//

import SwiftUI
import Firebase

struct ReauthenticateView: View {
    
    // MARK: - Properties
    @AppStorage("isLogged") var isLogged = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var manager: DataManager
    @FocusState private var focusedField: Field?
    @State private var email = ""
    @State private var password = ""
    @State private var circleY: CGFloat = 0
    @State private var emailY: CGFloat = 0
    @State private var passwordY: CGFloat = 0
    @State private var circleColor: Color = .blue
    @State private var appear = [false, false, false]
    @State private var showAlert = false
    @State private var showAlert1 = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            reauthenticateText
            bodyText
            inputs
        }
        .padding(20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
        .background(
            Circle().fill(circleColor)
                .frame(width: 68, height: 68)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .offset(y: circleY)
        )
        .coordinateSpace(name: "container")
        .strokeStyle(cornerRadius: 30)
        .onChange(of: focusedField) { value in
            withAnimation {
                if value == .email {
                    circleY = emailY
                    circleColor = .blue
                } else {
                    circleY = passwordY
                    circleColor = .red
                }
            }
        }
        .onAppear {
            appearAnimation()
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button("Retry", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .alert(alertTitle, isPresented: $showAlert1) {
            Button("Dismiss", role: .cancel) { dismiss() }
        } message: {
            Text(alertMessage)
        }
    }
}

// MARK: - Reauthenticate View Extension
private extension ReauthenticateView {
    
    // MARK: - Reauthenticate Text
    var reauthenticateText: some View {
        Text("Reauthenticate")
            .font(.largeTitle.bold())
            .opacity(appear[0] ? 1 : 0)
            .offset(y: appear[0] ? 0 : 20)
    }
    
    // MARK: - Body Text
    var bodyText: some View {
        Text("Reauthenticate Account")
            .font(.headline)
            .opacity(appear[1] ? 1 : 0)
            .offset(y: appear[1] ? 0 : 20)
    }
    
    // MARK: - Inputs
    var inputs: some View {
        Group {
            emailField
            passwordField
            reauthenticateButton
        }
        .opacity(appear[2] ? 1 : 0)
        .offset(y: appear[2] ? 0 : 20)
    }
    
    // MARK: - Email Field
    var emailField: some View {
        TextField("Email", text: $email)
            .inputStyle(icon: "mail")
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .focused($focusedField, equals: .email)
            .shadow(color: focusedField == .email ? .primary.opacity(0.3) : .clear, radius: 10, x: 0, y: 3)
            .overlay(geometry)
            .onPreferenceChange(CirclePreferenceKey.self) { value in
                emailY = value
                circleY = value
            }
    }
    
    // MARK: - Password Field
    var passwordField: some View {
        SecureField("Password", text: $password)
            .inputStyle(icon: "lock")
            .textContentType(.password)
            .focused($focusedField, equals: .password)
            .shadow(color: focusedField == .password ? .primary.opacity(0.3) : .clear, radius: 10, x: 0, y: 3)
            .overlay(geometry)
            .onPreferenceChange(CirclePreferenceKey.self) { value in
                passwordY =  value
            }
        
    }
    
    // MARK: - Reauthenticate Button
    var reauthenticateButton: some View {
        Button {
            reauthenticate()
        } label: {
            Text("Reauthenticate")
                .frame(maxWidth: .infinity)
        }
        .font(.headline)
        .blendMode(.hardLight)
        .buttonStyle(.angular)
        .tint(.accentColor)
        .controlSize(.large)
        .shadow(color: Color("Shadow").opacity(0.2), radius: 30, x: 0, y: 30)
    }
    
    // MARK: - Geometry
    var geometry: some View {
        GeometryReader { geo in
            Color.clear.preference(key: CirclePreferenceKey.self, value: geo.frame(in: .named("container")).minY)
        }
    }
}

// MARK: - Reauthenticate Functions Extension
private extension ReauthenticateView {
    
    // MARK: - Appear Animation Function
    func appearAnimation() {
        withAnimation(.spring().delay(0.1)) {
            appear[0] = true
        }
        withAnimation(.spring().delay(0.2)) {
            appear[1] = true
        }
        withAnimation(.spring().delay(0.3)) {
            appear[2] = true
        }
    }
    
    // MARK: - Reauthenticate Function
    func reauthenticate() {
        guard let user = Auth.auth().currentUser else { return }
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        user.reauthenticate(with: credential) {  result, error in
            if let error = error {
                alertTitle = "Reauthentication Error"
                alertMessage = error.localizedDescription
                showAlert = true
            } else {
                alertTitle = "Success"
                alertMessage = "Your account has been deleted"
                showAlert1 = true
                user.delete()
                isLogged = false
            }
        }
        
    }
    
    // MARK: - Reset Function
    func reset() {
        email = ""
        password = ""
    }
}

struct ReauthenticateView_Previews: PreviewProvider {
    static var previews: some View {
        ReauthenticateView()
    }
}
