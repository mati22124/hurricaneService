//
//  postsView.swift
//  hurricaneService
//
//  Created by Mayank Tiku on 10/17/24.
//

import SwiftUI

struct postsView: View {
    
    // ViewModel
    @StateObject private var postViewModel = PostsViewModel()
    
    var body: some View {
        VStack {
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.darkPurp)
        /*.task {
            do {
                try await postViewModel.loadCurrentUser()
                try await postViewModel.getAllPosts()
                
            }catch {
                print("didnt get all posts or didnt get user")
            }
            
         }*/
    }
}

#Preview {
    postsView()
}

/*
VStack {
    Button {
       
    try? postViewModel.createPost(title: "Hello World", body: "This is a test post", author: "Mayank Tiku")
        
    }label: {
        Text("Create Post")
    }
  
} */
