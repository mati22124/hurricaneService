//
//  ContentView.swift
//  hurricaneService
//
//  Created by Mayank Tiku on 10/8/24.
//

import SwiftUI
import FirebaseAuth

struct rootView: View {
    @State var isPresented = false
    
    var body: some View {
        mainView(showLoginView: $isPresented)
        .onAppear(perform: {
            isPresented = Auth.auth().currentUser == nil
        })
        .fullScreenCover(isPresented: $isPresented) {
            SignInView(showLoginView: $isPresented)
        }
    }
}

#Preview {
    rootView()
}
