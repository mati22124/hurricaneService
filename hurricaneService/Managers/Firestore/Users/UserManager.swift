//
//  UserManager.swift
//  hurricaneService
//
//  Created by Suraj Nistala on 10/20/24.
//

import Foundation
//Get singleton database type Firestore.firestore()
import FirebaseFirestore





final class UserManager {
    
    // static variable create one instance of the class// singleton. Have one instance handle all user data
    static let shared = UserManager()
    private init() {}
    
    //we use the same colleciton in this class so easier to use
    private let usercollection = Firestore.firestore().collection("users")
    
    
    // we look at the user document just to make it easier to type out
    private func userDocument(userId: String) -> DocumentReference {
        usercollection.document(userId)
    }
    
   
    
}




















//MARK: Create User and add data to it

extension UserManager {
    func createNewUser(user:DBUser)  throws {
        try  userDocument(userId: user.id).setData(from: user,merge: false)
        print("user in database created")
    }

}




//MARK: Retrieve data
extension UserManager {
    
    
    
    //first get the document reference aka snapshot aka document with user data in firebase form
    //then get snapshot data in the form of our decodable struct
    func getUser(userId:String) async throws -> DBUser{
        
        let snapshot = try await userDocument(userId: userId).getDocument()
       
  
        return try snapshot.data(as: DBUser.self)
        
    }
    
   
    
    
    //Gets all users documents look at getddocuments function comments
    func getAllUsers() async throws -> [DBUser] {
        
        try await usercollection.getDocuments(as: DBUser.self)
        
    }
    
    
   
   
   
}




//MARK: Delete data
extension UserManager {
    
    
    func removeUser(userId:String) async throws {
        
        //delete document after first deleting the sub documents
        try await userDocument(userId: userId).delete()
        
        
    }

}






//MARK: custom encoder decoder
extension UserManager {
    
    //custom coding keys if we want here in snake case photURL = photo_url
    
    private var encoder: Firestore.Encoder {
        
        let encoder = Firestore.Encoder()
       // encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
     /*
     private let decoder: Firestore.Decoder = {
         
         let decoder = Firestore.Decoder()
         decoder.keyDecodingStrategy = .convertToSnakeCase
         return decoder
     }
     
     
     
     */
    
}


//Get multiple documents and decode them into any data type custom function for all "Query types", basically all searches into any collection
//create new getDocuments function that can be codable
extension Query {
    
    //get documents from firebase async
    //throws as might get error from retrieving the object
    //Creates Generic T that must conform to decodable to be used in codable function "documents.data(as)"
    //Returns list of that generic type
    
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T: Decodable {
        
        //snapshot all documents in collection
        let snapshot = try await self.getDocuments()
        
        //Maps all documents in the collection as T into one list and returns it
        return try snapshot.documents.map({ document in
            try document.data(as: T.self)
            
        })
        
    }
    
    
    
    
    

    
    
}

