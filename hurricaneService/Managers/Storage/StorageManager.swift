//
//  StorageManager.swift
//  hurricaneService
//
//  Created by Suraj Nistala on 10/23/24.
//

import Foundation
import FirebaseStorage


final class StorageManager {
    
    //create singleton to have one item manage all the photos for profile photos
    static let shared = StorageManager()
    private init() {}
    
    //get basically id to firebase storage, after creating it in the firebase server
    private let storage = Storage.storage().reference()
    
    //create a folder for all images in the storage
    private var imageReference: StorageReference {
        storage.child("images")
    }
    
    //create a folder for all specific user's images, using their id, in images folder
    private func userReference(userId: String) -> StorageReference {
        imageReference.child("users").child(userId)
    }
    
    
    //create a folder for all specific posts's images, using their id, in images folder
    private func postReference(postId: String) -> StorageReference {
        imageReference.child("posts").child(postId)
    }
    
    
    
    
    //create a folder for all specific posts's images, using their id, in images folder
    private func courseReference(courseId: String) -> StorageReference {
        imageReference.child("courses").child(courseId)
    }
    
    
    //simple because we reuse it
    func getPathForImage(path:String) -> StorageReference {
        Storage.storage().reference(withPath: path)
    }
    
    
    //download async image, so you need URL, this gets the download url of the photo from Firebase
    func getURLForImage(path:String) async throws -> URL {
        
        //the FULL path will be needed and then the downlaod url will be taken from there
        try await getPathForImage(path: path).downloadURL()
        
    }
    
    
    
    //takes type data that contains image(its basically taken from ui image), need userId to put the image in the users folder
    //look to nics video if you want to change this to also be able to save any UIImage not just data taken from it
        //saveImage(image:UIImage,userId:String),
    func saveImage(data:Data, userId: String, childId: String?=nil) async throws -> (path: String, name: String) {
        
        
        //create meta so that firebase knows to make it a jpeg image
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        //make a random path for every image uploaded
        //png has transparent background but larger file size
        let path = "\(UUID().uuidString).jpeg"
        
        
        //upload image to the users folder asyncrounisly with the image data and its metadata, firebase will convert it
        //change reference depending on if we upload to child or user, pass "" as a vlaue meaning childId doesn't exist
        //could make more eficient prob dont need to use two functions
        let returnedMetaData = try await saveInReference(data: data, userId: userId, childId: childId ?? "", path: path, meta: meta)
        
        
        guard let returnedPath = returnedMetaData.path, let returnedName = returnedMetaData.name else {
            throw URLError(.badURL)
        }
        
        return (returnedPath,returnedName)
        
        
    }
    
    
    //helper function to return if its a child or not
    func saveInReference(data:Data, userId: String, childId: String, path: String, meta: StorageMetadata) async throws -> StorageMetadata {
        //defualt value if childId doesnt exist
        try await userReference(userId: userId).child(path).putDataAsync(data,metadata: meta)
    }
    
 
    
    
    
    
    //gets path and then deletes it in the database
    func deleteImage(path:String) async throws  {
        try await getPathForImage(path: path).delete()
    }
    
    
}




//Posts

extension StorageManager {
    
    
    //takes type data that contains image(its basically taken from ui image), need userId to put the image in the users folder
    //look to nics video if you want to change this to also be able to save any UIImage not just data taken from it
        //saveImage(image:UIImage,userId:String),
    func saveImage(data:Data, postId: String) async throws -> (path: String, name: String) {
        
        
        //create meta so that firebase knows to make it a jpeg image
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        //make a random path for every image uploaded
        //png has transparent background but larger file size
        let path = "\(UUID().uuidString).jpeg"
        
        
        //upload image to the users folder asyncrounisly with the image data and its metadata, firebase will convert it
        //change reference depending on if we upload to child or user, pass "" as a vlaue meaning childId doesn't exist
        //could make more eficient prob dont need to use two functions
        let returnedMetaData = try await saveInReference(data: data, postId: postId, path: path, meta: meta)
        
        
        guard let returnedPath = returnedMetaData.path, let returnedName = returnedMetaData.name else {
            throw URLError(.badURL)
        }
        
        return (returnedPath,returnedName)
        
        
    }
    
    
    //helper function to return if its a child or not for posts
    func saveInReference(data:Data, postId: String, path: String, meta: StorageMetadata) async throws -> StorageMetadata {
        //defualt value if childId doesnt exist
        try await postReference(postId: postId).child(path).putDataAsync(data,metadata: meta)
    }
    
    
    
    
    
    
}











