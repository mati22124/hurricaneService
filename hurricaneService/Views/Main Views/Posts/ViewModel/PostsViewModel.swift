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
    @Published private(set) var posts: [DBPost] = []


    
    //LoadUser
    func loadCurrentUser() async throws {
        let authDataResult = try authManager.shared.getAuthUser()
        self.user = try await UserManager.shared.getUser(userId: authDataResult.uid)
       
        
     
        
    }
  
    //Create post
    func createPost(title: String, body: String, author: String, topic: String)  throws {
        let post = DBPost(id: UUID().uuidString, title: title, body: body, author: author, topic: topic)
        
        try PostManager.shared.createNewPost(post: post)
        
        guard let user = user else {
            return
        }
        
    
        let usersPost = DBUsersPost(id: UUID().uuidString, userId: user.id, postId: post.id)
        
        try UserManager.shared.addUsersPost(userId: user.id, usersPost: usersPost)
        
        
    }
    
    
    
    
    
    
    
    //Get Posts
    func getAllPosts() async throws {
        posts = try await PostManager.shared.getAllPosts()
    }
    
    
    
}


