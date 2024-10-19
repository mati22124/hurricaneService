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
    
    @Published var shelters: [Shelter] = [
        Shelter(name: "City Hall", location: CLLocation(latitude: 29.7604, longitude: -95.3698), supplies: ["Water": 500, "Food": 300, "Beds": 100]),
        Shelter(name: "Community Center", location: CLLocation(latitude: 29.7522, longitude: -95.3524), supplies: ["Water": 300, "Food": 200, "Beds": 75]),
        Shelter(name: "High School Gym", location: CLLocation(latitude: 29.7707, longitude: -95.3855), supplies: ["Water": 700, "Food": 500, "Beds": 150])
    ]
    
    func findDistance(current currentLoc: CLLocation?, shelter: Shelter) -> String {
        let miles = shelter.location.distance(from: currentLoc ?? shelter.location)*0.00062137119224
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
}
