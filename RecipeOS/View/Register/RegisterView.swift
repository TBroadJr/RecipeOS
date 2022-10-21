//
//  RegisterView.swift
//  RecipeOS
//
//  Created by Tornelius Broadwater, Jr on 9/17/22.
//

import SwiftUI

struct RegisterView: View {
    
    // MARK: - Properties
    @AppStorage("isLogged") var isLogged = false
    @AppStorage("showRegister") var showRegister = true
    @EnvironmentObject var manager: DataManager
    @State private var viewState: CGSize = .zero
    @State private var isDismissed = false
    @State private var appear = [false, false, false]
    
    // MARK: - Body
    var body: some View {
        ZStack {
            background
            display
            dismissButton
        }
        .onAppear {
            animate()
        }
        .onChange(of: isLogged) { newValue in
            if newValue {
                dismiss()
            }
        }
    }
}

// MARK: - RegisterView Extension
private extension RegisterView {
    
    // MARK: - Background
    private var background: some View {
        Color.clear
            .background(.ultraThinMaterial)
            .ignoresSafeArea()
    }
    
    // MARK: - Display
    private var display: some View {
        Group {
            switch manager.registerType {
            case .signUp: SignUpView()
            case .signIn: SignInView()
            case .reauthenticate: ReauthenticateView()
                
            }
        }
        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .offset(x: viewState.width, y: viewState.height)
        .offset(y: isDismissed ? 1000 : 0)
        .rotationEffect(.degrees(viewState.width / 40))
        .rotation3DEffect(.degrees(viewState.height / 20), axis: (x: 1, y: 0, z: 0))
        .hueRotation(.degrees(viewState.height / 5))
        .gesture(drag)
        .shadow(color: Color("Shadow").opacity(0.2), radius: 30, x: 0, y: 30)
        .opacity(appear[0] ? 1 : 0)
        .offset(y: appear[0] ? 0 : 200)
        .padding(20)
        .background(backgroundBlob)
        
    }
    
    // MARK: - Dismiss Button
    private var dismissButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.body.bold())
                .foregroundColor(.secondary)
                .padding(8)
                .background(.ultraThinMaterial, in: Circle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .padding(20)
        .opacity(appear[1] ? 1 : 0)
        .offset(y: appear[1] ? 0 : -200)
    }
    
    // MARK: - Background Blob
    private var backgroundBlob: some View {
        Image("Blob 1")
            .offset(x: 200, y: -100)
            .opacity(appear[2] ? 1 : 0)
            .offset(y: appear[2] ? 0 : 10)
            .blur(radius: appear[2] ? 0 : 40)
            .allowsHitTesting(false)
    }
    
    // MARK: - Drag Gesture
    private var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                viewState = value.translation
            }
            .onEnded { value in
                if value.translation.height > 200 {
                    dismiss()
                } else {
                    withAnimation(.openCard) {
                        viewState = .zero
                    }
                }
            }
    }
}

// MARK: - RegisterView Functions Extension
private extension RegisterView {
    
    // MARK: - Dismiss Function
    private func dismiss() {
        withAnimation {
            isDismissed = true
        }
        withAnimation(.linear.delay(0.1)) {
            showRegister = false
        }
        
    }
    
    // MARK: - Animate Function
    private func animate() {
        withAnimation(.easeOut) {
            appear[0] = true
        }
        withAnimation(.easeOut.delay(0.1)) {
            appear[1] = true
        }
        withAnimation(.easeOut(duration: 1).delay(0.2)) {
            appear[2] = true
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RegisterView()
                .environmentObject(DataManager())
            RegisterView()
                .preferredColorScheme(.dark)
                .environmentObject(DataManager())
        }
    }
}
