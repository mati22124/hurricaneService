//
//  Untitled.swift
//  hurricaneService
//
//  Created by Mayank Tiku on 10/19/24.
//

import Foundation
import FirebaseFirestore

final class shelterManager {
    static let shared = shelterManager()
    private init() {}
    
    let db = Firestore.firestore()
    
    func getShelters() async throws -> [Shelter] {
        var shelters: [Shelter] = []
        let snapshot = try await db.collection("shelters").getDocuments()
        
        for doc in snapshot.documents {
            shelters.append(try doc.data(as: Shelter.self))
        }
        return shelters
    }
    
    func addShelter(_ shelter: Shelter) throws {
        try db.collection("shelters").addDocument(from: shelter)
    }
    
    func addShelters(_ shelter: [Shelter])  throws {
        for shelter in shelter {
            try db.collection("shelters").addDocument(from: shelter)
        }
    }
}
