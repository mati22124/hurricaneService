//
//  PostsViewModel.swift
//  hurricaneService
//
//  Created by Suraj Nistala on 10/22/24.
//

import Foundation


@MainActor
final class PostsViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    @Published private(set) var post: [DBPost] = []


    
    //LoadUser
    func loadCurrentUser() async throws {
        let authDataResult = try authManager.shared.getAuthUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
       
        
     
        
    }
  
    //Create post
    func createPost(title: String, body: String, author: String)  throws {
        let post = DBPost(id: UUID().uuidString, title: title, body: body, author: author)
        
        try PostManager.shared.createNewPost(post: post)
        
        guard let user = user else {
            return
        }
        
    
        let usersPost = DBUsersPost(id: UUID().uuidString, userId: user.id, postId: post.id)
        
        try UserManager.shared.addUsersPost(userId: user.id, usersPost: usersPost)
        
        
    }
    
    
    
    
    
    
    
    //Get Posts
    func getAllPosts() async throws {
        post = try await PostManager.shared.getAllPosts()
    }
    
    
    
}


