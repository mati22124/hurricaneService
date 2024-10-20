import SwiftUI
import Firebase
import GoogleSignIn
import AuthenticationServices

struct SignInView: View {
    @State private var isSigningUp = false
    @Binding var showLoginView: Bool
    
    @StateObject private var viewModel = signInViewModel()
    
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
                    
                    Text("StormGuard")
                        .font(.custom("ProductSans-Bold", size: 40))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 20) {
                    TextField("", text: $viewModel.email, prompt: Text("Email").foregroundStyle(.white).font(.custom("ProductSans-Regular", size: 16)))
                        .textFieldStyle(ModernTextFieldStyle())
                    VStack {
                        SecureField("", text: $viewModel.password, prompt: Text("Password").foregroundStyle(.white).font(.custom("ProductSans-Regular", size: 16)))
                        .textFieldStyle(ModernTextFieldStyle())
                        HStack {
                            Button {
                                // place here
                            } label: {
                                Text("Forgot password?")
                                    .padding(.leading, 15)
                                    .font(.custom("ProductSans-Regular", size: 13))
                                    .foregroundColor(.white)
                            }
                            
                            Spacer()
                        }
                    }
                }
                .padding(.top, 5)
                VStack(spacing: 15) {
                    Button(action: {
                        Task {
                            do {
                                try await viewModel.signIn()
                                showLoginView = false
                            } catch {
                                print("error \(error)")
                            }
                        }
                    }) {
                        Text("Log In")
                            .font(.custom("ProductSans-Bold", size: 18))
                            .foregroundColor(backgroundColor)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(accentColor)
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
                        isSigningUp.toggle()
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
                    
                    Button(action: {
                        Task {
                            do {
                                try await viewModel.signInGoogle()
                                showLoginView = false
                            } catch {
                                print("error \(error)")
                            }
                        }
                    }) {
                        HStack {
                            Image("googleLogo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.red)
                            Text("Sign in with Google")
                                .font(.custom("ProductSans-Bold", size: 18))
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    }
                    Button {
                        Task {
                            do {
                                try await viewModel.signInApple()
                            } catch {
                                print("error \(error)")
                            }
                        }
                    } label: {
                        HStack {
                            Image("appleLogo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.red)
                            Text("Sign in with Apple")
                                .font(.custom("ProductSans-Bold", size: 18))
                        }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
                    }
                    .clipShape(Capsule())
                    .frame(height: 60)
                    .onChange(of: viewModel.signedInWithApple) { oldValue, newValue in
                        if newValue {
                            showLoginView = false
                        }
                    }
                }
            }
            .padding(.horizontal, 30)
        }
        .fullScreenCover(isPresented: $isSigningUp) {
            signUpView(showSignUpView: $isSigningUp, showLoginView: $showLoginView)
        }
    }
}

struct ModernTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(red: 0.3, green: 0.3, blue: 0.6))
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
            .autocapitalization(.none)
            .autocorrectionDisabled()
            .foregroundStyle(.white)
            .font(.custom("ProductSans-Regular", size: 16))
            .tint(.white)
    }
}

struct SignInWithAppleButtonViewRepresentable: UIViewRepresentable {
    
    let type: ASAuthorizationAppleIDButton.ButtonType
    let style: ASAuthorizationAppleIDButton.Style
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        ASAuthorizationAppleIDButton(type: type, style: style)
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
        
    }
}

#Preview {
    SignInView(showLoginView: .constant(true))
}
