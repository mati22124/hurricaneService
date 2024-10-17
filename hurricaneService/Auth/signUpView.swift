//
//  SignUpView.swift
//  hurricaneService
//
//  Created by Mayank Tiku on 10/15/24.
//

import SwiftUI
import Firebase


struct signUpView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    @Binding var showSignUpView: Bool
    @Binding var showLoginView: Bool
    
    @StateObject var viewModel = signUpViewModel()
    
    let backgroundColor = Color(red: 0.2, green: 0.2, blue: 0.5) // Dark storm blue
    let accentColor = Color(red: 1.0, green: 0.6, blue: 0.0) // Warning orange
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all).opacity(0.9)
            
            VStack(spacing: 15) {
                VStack(spacing: 10) {
                    Image(systemName: "water.waves")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(accentColor)
                    
                    Text("storm Watch")
                        .font(.custom("ProductSans-Bold", size: 40))
                        .foregroundColor(.white)
                }
                
                
                VStack(spacing: 15) {
                    TextField("", text: $viewModel.email, prompt: Text("Email").foregroundStyle(.white).font(.custom("ProductSans-Regular", size: 16)))
                        .textFieldStyle(ModernTextFieldStyle())
                    SecureField("", text: $viewModel.password, prompt: Text("Password").foregroundStyle(.white).font(.custom("ProductSans-Regular", size: 16)))                        .textFieldStyle(ModernTextFieldStyle())
                    SecureField("", text: $viewModel.confirmPassword, prompt: Text("Confirm Password").foregroundStyle(.white).font(.custom("ProductSans-Regular", size: 16)))                        .textFieldStyle(ModernTextFieldStyle())
                       
                }
                .padding(.top, 5)
                .padding(.bottom,5)
                VStack(spacing: 15) {
                    Button(action: {
                        Task {
                            do {
                                try await viewModel.signUp()
                                showLoginView = false
                                showSignUpView = false
                            } catch {
                                print("error \(error)")
                            }
                        }
                    }) {
                        Text("Sign Up")
                            .font(.custom("ProductSans-Bold", size: 18))
                            .foregroundColor(backgroundColor)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .clipShape(Capsule())
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    }
                    HStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.white)
                            .frame(width: 100, height: 1, alignment: .leading)
                        Text("or")
                            .foregroundStyle(.white)
                            .font(.custom("ProductSans-Regular", size: 16))
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.white)
                            .frame(width: 100, height: 1, alignment: .leading)
                    }
                    
                    Button(action: {
                        showSignUpView.toggle()
                    }) {
                        Text("Log In")
                            .font(.custom("ProductSans-Bold", size: 18))
                            .foregroundColor(backgroundColor)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .clipShape(Capsule())
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    }
                    
                    
                }
            }
            .padding(.horizontal, 30)
        }
    }
}


#Preview {
    signUpView(showSignUpView: .constant(true), showLoginView: .constant(true))
}
