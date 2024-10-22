//
//  PostManager.swift
//  hurricaneService
//
//  Created by Suraj Nistala on 10/22/24.
//

import Foundation
//Get singleton database type Firestore.firestore()
import FirebaseFirestore





struct DBPost: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let body: String
    let author: String
    let createdAt: Date
}



final class PostManager {
    
    // static variable create one instance of the class// singleton. Have one instance handle all user data
    static let shared = PostManager()
    private init() {}
    
    //we use the same colleciton in this class so easier to use
    private let postcollection = Firestore.firestore().collection("posts")
    
    
    // we look at the user document just to make it easier to type out
    private func postDocument(postId: String) -> DocumentReference {
        postcollection.document(postId)
    }
    
   
    
}



//MARK: custom encoder decoder
extension PostManager {
    private var encoder: Firestore.Encoder {
        let encoder = Firestore.Encoder()
        return encoder
    }
   
    
}


//MARK: Create User and add data to it

extension PostManager {
    func createNewPost(post:DBPost)  throws {
        try  postDocument(postId: post.id).setData(from: post,merge: false)
        print("post in database created")
    }

}




//MARK: Retrieve data
extension PostManager {
    
    
    func getPost(postId:String) async throws -> DBPost{
        
        let snapshot = try await postDocument(postId: postId).getDocument()
        return try snapshot.data(as: DBPost.self)
        
    }
    
    
    func getAllPosts() async throws -> [DBPost] {
        try await postcollection.getDocuments(as: DBPost.self)
        
    }
    
    
   
   
   
}
