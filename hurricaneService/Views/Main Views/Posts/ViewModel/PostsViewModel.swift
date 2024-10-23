//
//  PostsViewModel.swift
//  hurricaneService
//
//  Created by Suraj Nistala on 10/22/24.
//

import Foundation
import SwiftUI
import PhotosUI

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
    func createPost(title: String, body: String, topic: String, photo: PhotosPickerItem)  async throws {
        
        guard let user = user else {
            return
        }
        
        let post = DBPost(id: UUID().uuidString, title: title, body: body, author: user.email, topic: topic, photoURL: "", photoPath: "")
    
        try PostManager.shared.createNewPost(post: post)
        
        try await saveProfileImage(item: photo, postId: post.id)
        
        let usersPost = DBUsersPost(id: UUID().uuidString, userId: user.id, postId: post.id)
        
        try UserManager.shared.addUsersPost(userId: user.id, usersPost: usersPost)
        
        
    }
    
    
    
    
    
    
    
    //Get Posts
    func getAllPosts() async throws {
        posts = try await PostManager.shared.getAllPosts()
    }
    
    
    
    
    
}



//Images

extension PostsViewModel {
    
   
    
    func saveProfileImage(item:PhotosPickerItem, postId: String) async throws {
        
        
            guard let data = try await item.loadTransferable(type: Data.self) else {return}

            let (path,_) = try await StorageManager.shared.saveImage(data: data, postId: postId)

            let url = try await StorageManager.shared.getURLForImage(path: path)

            try await PostManager.shared.updatePhotoPost(postId: postId, path: path, url: url.absoluteString)
      
        
        
        
        
        
    }
    
    
 
    
    
    
    
    
    
}
