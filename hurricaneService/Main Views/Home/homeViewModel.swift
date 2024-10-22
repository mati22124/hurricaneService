//
//  homeViewModel.swift
//  hurricaneService
//
//  Created by Mayank Tiku on 10/18/24.
//

import Foundation
import CoreLocation
import MapKit

final class homeViewModel: ObservableObject {
    @Published var locManager = LocationManager()
    
    @Published var shelters: [Shelter] = []
    
    func findDistance(current currentLoc: CLLocation?, shelter: Shelter) -> String {
        let shelLoc = CLLocation(latitude: shelter.latitude, longitude: shelter.longitude)
        let miles = shelLoc.distance(from: currentLoc ?? shelLoc)*0.00062137119224
        if miles == 0  {
            return "Distance not available"
        }
        let milesRounded = (miles*10).rounded()/10
        return "\(milesRounded.formatted()) miles away"
    }
    
    func openInMaps(coordinate: CLLocation, name: String) {
        let placemark = MKPlacemark(coordinate: coordinate.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        mapItem.openInMaps(launchOptions: nil)
    }
    
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
