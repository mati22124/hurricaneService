//
//  ContentView.swift
//  hurricaneService
//
//  Created by Mayank Tiku on 10/8/24.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State var isPresented = false
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .onAppear(perform: {
            isPresented = Auth.auth().currentUser == nil
        })
        .fullScreenCover(isPresented: $isPresented) {
            SignInView(showLoginView: $isPresented)
        }
    }
}

#Preview {
    ContentView()
}
