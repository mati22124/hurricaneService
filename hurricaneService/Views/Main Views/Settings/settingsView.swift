//
//  settingsView.swift
//  hurricaneService
//
//  Created by Mayank Tiku on 10/17/24.
//

import SwiftUI

struct settingsView: View {
    
    
    // ViewModel
    @StateObject private var settingsViewModel = SettingsViewModel()
    
    @Binding var showLoginView: Bool
    
    @State var isPresented: Bool = false
    
    var body: some View {
        VStack {
            if let user = settingsViewModel.user {
                Text("Name:"+user.email)
                Button {
                    try? settingsViewModel.logOut()
                    showLoginView = true
                } label: {
                    Text("Sign Out")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.darkPurp)
        .task {
            
            do {
                try await settingsViewModel.loadCurrentUser()
            }catch {
                print("couldn't get user")
            }
            
        }
    }
}

#Preview {
    settingsView(showLoginView: .constant(false))
}
