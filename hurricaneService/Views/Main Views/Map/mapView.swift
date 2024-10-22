//
//  mapView.swift
//  hurricaneService
//
//  Created by Mayank Tiku on 10/17/24.
//

import SwiftUI
import MapKit

struct mapView: View {
    @StateObject var locManager = LocationManager()
    @StateObject var viewModel = mapViewModel()
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    
    var body: some View {
        Map(position: $position) {
            
            UserAnnotation()
            
            ForEach(viewModel.shelters) { shelter in
                Marker(shelter.name, coordinate: CLLocationCoordinate2D(latitude: shelter.latitude, longitude: shelter.longitude))
            }
        }
        .mapControls({
            MapUserLocationButton().padding()
        })
        .onAppear() {
            locManager.checkLocationAuthorization()
            Task {
                do {
                    try await viewModel.getShelters()
                } catch {
                    print("Error fetching shelters: \(error)")
                }
            }
        }
    }
}

#Preview {
    mapView()
}
