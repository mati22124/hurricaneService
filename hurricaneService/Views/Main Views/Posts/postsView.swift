//
//  postsView.swift
//  hurricaneService
//
//  Created by Mayank Tiku on 10/17/24.
//

import SwiftUI


// Post row view
struct PostRowView: View {
    let post: DBPost
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack {
                Text("Topic: \(post.topic)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                Text("• Posted by u/\(post.author)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("2h ago")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            // Title
            Text(post.title)
                .font(.headline)
                .lineLimit(3)
            
            // Photo
           
            
            // DM Button
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}




// Main posts view
struct PostsView: View {
    
    
    @StateObject var postsViewModel = PostsViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(postsViewModel.posts) { post in
                        PostRowView(post: post)
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Posts")
            .navigationBarTitleTextColor(.white)
            .navigationBarItems(trailing: Button(action: {}) {
                Image(systemName: "plus")
                    .foregroundStyle(.white)
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.darkPurp)
            .task {
                do {
                    try await postsViewModel.loadCurrentUser()
                    try await postsViewModel.getAllPosts()
                }catch {
                    print("didn't get user or posts")
                }
            }
        }
    }
}



#Preview {
    PostsView()
}



/*
VStack {
    Button {
       
    try? postViewModel.createPost(title: "Hello World", body: "This is a test post", author: "Mayank Tiku")
        
    }label: {
        Text("Create Post")
    }
  
} */
