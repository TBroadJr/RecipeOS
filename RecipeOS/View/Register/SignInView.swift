//
//  SignInView.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/17/22.
//

import SwiftUI
import Firebase

struct SignInView: View {
    
    // MARK: - Properties
    @AppStorage("isLogged") var isLogged = false
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
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            signInText
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
    }
}

// MARK: - SignInView Extension
private extension SignInView {
    
    // MARK: - Sign In Text
    private var signInText: some View {
        Text("Sign in")
            .font(.largeTitle.bold())
            .opacity(appear[0] ? 1 : 0)
            .offset(y: appear[0] ? 0 : 20)
    }
    
    // MARK: - Body Text
    private var bodyText: some View {
        Text("Gain access to 100's of recipes and create your own")
            .font(.headline)
            .opacity(appear[1] ? 1 : 0)
            .offset(y: appear[1] ? 0 : 20)
    }
    
    // MARK: - Inputs
    private var inputs: some View {
        Group {
            emailField
            passwordField
            signInButton
            Divider()
            bottomText
        }
        .opacity(appear[2] ? 1 : 0)
        .offset(y: appear[2] ? 0 : 20)
    }
    
    // MARK: - Email Field
    private var emailField: some View {
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
    private var passwordField: some View {
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
    
    // MARK: - Sign In Button
    private var signInButton: some View {
        Button {
            signIn()
        } label: {
            Text("Sign in")
                .frame(maxWidth: .infinity)
        }
        .font(.headline)
        .blendMode(.hardLight)
        .buttonStyle(.angular)
        .tint(.accentColor)
        .controlSize(.large)
        .shadow(color: Color("Shadow").opacity(0.2), radius: 30, x: 0, y: 30)
    }
    
    // MARK: - Bottom Text
    private var bottomText: some View {
        HStack {
            Text("No account yet?")
            Button {
                manager.registerType = .signUp
            } label: {
                Text("**sign up**")
            }
        }
        .font(.footnote)
        .foregroundColor(.secondary)
        .accentColor(.secondary)
    }
    
    // MARK: - Geometry
    private var geometry: some View {
        GeometryReader { geo in
            Color.clear.preference(key: CirclePreferenceKey.self, value: geo.frame(in: .named("container")).minY)
        }
    }
}

// MARK: - SignInView Functions Extension
private extension SignInView {
    
    // MARK: - Appear Animation Function
    private func appearAnimation() {
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
    
    // MARK: - SignIn Function
    private func signIn() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                showAlert = true
                alertTitle = "Sign In Error"
                alertMessage = error.localizedDescription
            } else {
                isLogged = true
            }
        }
    }
    
    // MARK: - Reset Function
    private func reset() {
        email = ""
        password = ""
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .environmentObject(DataManager())
            .preferredColorScheme(.dark)
    }
}
