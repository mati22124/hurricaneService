//
//  addPostView.swift
//  hurricaneService
//
//  Created by Suraj Nistala on 10/23/24.
//

import SwiftUI


struct AddPostView: View {
    @Environment(\.dismiss) var dismiss
    @State private var postTitle = ""
    @State private var postContent = ""
    @State private var isLoading = false
    
    @StateObject var postsViewModel = PostsViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Post Details")) {
                    TextField("Title", text: $postTitle)
                        .padding(.vertical, 8)
                    
                    TextEditor(text: $postContent)
                        .frame(height: 150)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                }
                .task {
                    do {
                        //dont need to just safe
                        try await postsViewModel.loadCurrentUser()
                        
                    }catch {
                        print("couldn't get user")
                    }
                }
            }
            .navigationTitle("New Post")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Post") {
                    submitPost()
                }
                .disabled(postTitle.isEmpty || postContent.isEmpty)
            )
            
            .overlay {
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.4))
                }
            }
        }
    }
    
    private func submitPost() {
        Task {
            isLoading = true
            
            do {
                try  postsViewModel.createPost(title: postTitle, body: postContent, topic: "nil")
            }catch {
                print("couldnt add post")
            }
            
            isLoading = false
        }
        
    }
}

// Preview provider for SwiftUI canvas
struct AddPostView_Previews: PreviewProvider {
    static var previews: some View {
        AddPostView()
    }
}
