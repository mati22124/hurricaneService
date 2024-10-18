//
//  settingsView.swift
//  hurricaneService
//
//  Created by Mayank Tiku on 10/17/24.
//

import SwiftUI

struct settingsView: View {
    @Binding var showLoginView: Bool
    
    var body: some View {
        VStack {
            Text("settings")
            Button {
                try? authManager.shared.signOut() // MARK: suraj pls take this out, create VM, and then put it into VM
                showLoginView = true
            } label: {
                Text("Sign Out")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.darkPurp)
    }
}

#Preview {
    settingsView(showLoginView: .constant(false))
}
