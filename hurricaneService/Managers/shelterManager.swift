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
}
