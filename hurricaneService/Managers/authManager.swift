//
//  authManager.swift
//  grades
//
//  Created by Mayank Tiku on 9/25/24.
//

import FirebaseAuth

struct authResult {
    let email: String?
    let uid: String
    let photoURL: String?
    
    init(user: User) {
        email = user.email
        uid = user.uid
        photoURL = user.photoURL?.absoluteString
        
    }
}

final class authManager {
    
    static let shared = authManager()
    private init() {}
    
    func createUser(email: String, password: String) async throws -> authResult {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return authResult(user: authDataResult.user)
    }
    
    func getAuthUser() throws -> authResult {
        guard let authDataResult = Auth.auth().currentUser else {
            throw authError.noUser
        }
        return authResult(user: authDataResult)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func signIn(email: String, password: String) async throws -> authResult {
        let authResultt = try await Auth.auth().signIn(withEmail: email, password: password)
        return authResult(user: authResultt.user)
    }
    
    func signInWithCredential(idToken: String, accessToken: String) async throws -> authResult {
        let authResultt = try await Auth.auth().signIn(with: GoogleAuthProvider.credential(withIDToken: idToken,
                                                                                           accessToken: accessToken))
        return authResult(user: authResultt.user)
    }
    
    func signInWithApple(withIDToken: String, rawNonce: String, fullName: PersonNameComponents?) async throws -> authResult {
        guard let full = fullName else {
            throw authError.noUser
        }
        let credential = OAuthProvider.appleCredential(withIDToken: withIDToken, rawNonce: rawNonce, fullName: full)
        let authResultt = try await Auth.auth().signIn(with: credential)
        return authResult(user: authResultt.user)
    }
    
}


enum authError: Error {
    case invalidEmail
    case invalidPassword
    case noUser
    case noEmailOrPassword
    case passwordsNoMatch
}
