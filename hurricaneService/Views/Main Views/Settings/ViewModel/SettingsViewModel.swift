//
//  SettingsViewModel.swift
//  hurricaneService
//
//  Created by Suraj Nistala on 10/20/24.
//

import Foundation
//need to import swiftui to get photospicer
import SwiftUI
import PhotosUI

@MainActor
final class SettingsViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil


    
    //LoadUser
    func loadCurrentUser() async throws {
        let authDataResult = try authManager.shared.getAuthUser()
     
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
       
        
     
        
    }
    
    //Logout
    func logOut() throws {
        try authManager.shared.signOut()
    }
    
    func deleteAcc() async throws {
        try await authManager.shared.deleteAccount()
    }
  
    
    
}


