//
//  signInViewModel.swift
//  hurricaneService
//
//  Created by Mayank Tiku on 10/11/24.
//


//
//  authViewModel.swift
//  grades
//
//  Created by Mayank Tiku on 9/25/24.
//

import Foundation
import Firebase
import GoogleSignIn
import CryptoKit
import AuthenticationServices

@MainActor
final class signInViewModel: NSObject, ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    @Published var signedInWithApple: Bool = false
    
    private var currentNonce: String?
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("email or password empty")
            throw authError.noEmailOrPassword
        }
        
        let _ = try await authManager.shared.signIn(email: email, password: password)
    }
    
    func signInGoogle() async throws {
        guard let topVC = UIApplication.topViewController() else {
            print("cant find topvc")
            throw URLError(.badURL)
        }
        let gidsigninresult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        let accessToken = gidsigninresult.user.accessToken.tokenString
        
        guard let idToken = gidsigninresult.user.idToken?.tokenString else {
            print("no id token")
            throw URLError(.badURL)
        }
        
        let _ = try await authManager.shared.signInWithCredential(idToken: idToken, accessToken: accessToken)
    }
    
    func signInApple() async throws {
        startSignInWithAppleFlow()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      var randomBytes = [UInt8](repeating: 0, count: length)
      let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
      if errorCode != errSecSuccess {
        fatalError(
          "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
      }

      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")

      let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
      }

      return String(nonce)
    }

    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    func startSignInWithAppleFlow() {
        guard let topVC = UIApplication.topViewController() else { return }
        
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = topVC
        authorizationController.performRequests()
    }
}

extension signInViewModel: ASAuthorizationControllerDelegate {

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
      if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
          guard let nonce = currentNonce else {
              fatalError("Invalid state: A login callback was received, but no login request was sent.")
          }
          guard let appleIDToken = appleIDCredential.identityToken else {
              print("Unable to fetch identity token")
              return
          }
          guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
              print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
              return
          }
          // Initialize a Firebase credential, including the user's full name.
          Task {
              do {
                  let _ = try await authManager.shared.signInWithApple(withIDToken: idTokenString,
                                                                       rawNonce: nonce,
                                                                       fullName: appleIDCredential.fullName)
                  self.signedInWithApple = true
              } catch {
                  print("error \(error)")
              }
          }
      }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    print("Sign in with Apple errored: \(error)")
  }

}

@MainActor
final class signUpViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            print("email or password empty")
            throw authError.noEmailOrPassword
        }
        
        guard password == confirmPassword else {
            print("passwords do not match")
            throw authError.passwordsNoMatch
        }
        
        let _ = try await authManager.shared.createUser(email: email, password: password)
    }
}
