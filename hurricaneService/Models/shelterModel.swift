//
//  Shelter.swift
//  hurricaneService
//
//  Created by Mayank Tiku on 10/19/24.
//

import Foundation

struct Shelter: Identifiable, Codable {
    let id: UUID
    let name: String
    let latitude: Double
    let longitude: Double
    let supplies: [String: Int]
}
