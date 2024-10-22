//
//  DBEntries.swift
//  hurricaneService
//
//  Created by Suraj Nistala on 10/20/24.
//


struct DBUser: Codable, Identifiable, Hashable {
    let id: String
    let email: String
    

    //Photo
    let photoURL: String?
    let photoPath: String?
    
    let postsId: [String]
    
    init(authDataResult: authResult) {
        
        self.id = authDataResult.uid
        self.email = authDataResult.email ?? ""
        
        
        //just the defualt user
        self.photoPath = ""
        self.photoURL = authDataResult.photoURL
        
        self.postsId = []
        
        
    }

}



struct DBPost: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let body: String
    let author: String
    
}


struct DBUsersPost: Codable, Identifiable, Hashable {
    let id: String
    let userId: String
    let postId: String
}
