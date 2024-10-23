//
//  Shelter.swift
//  hurricaneService
//
//  Created by Mayank Tiku on 10/19/24.
//

import Foundation

struct Shelter: Identifiable, Codable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
    let supplies: [String: Int]
    let organization: String
    let address: String
    let city: String
    let state: String
    let zipCode: String
    let evacuationCap: Int
    let postCap: Int
}
