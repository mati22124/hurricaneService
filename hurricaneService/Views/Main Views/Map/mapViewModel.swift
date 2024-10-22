//
//  mapViewModel.swift
//  hurricaneService
//
//  Created by Mayank Tiku on 10/21/24.
//

import Foundation
import FirebaseAuth

final class mapViewModel: ObservableObject {
    @Published var locManager = LocationManager()
    
    @Published var shelters: [Shelter] = []
    
    func getShelters() async throws {
        shelters = try await shelterManager.shared.getShelters()
    }
    
    func addShelter(_ shelter: Shelter) throws {
        try shelterManager.shared.addShelter(shelter)
    }
    
    func addShelters(_ shelters: [Shelter]) throws {
        try shelterManager.shared.addShelters(shelters)
    }
}
