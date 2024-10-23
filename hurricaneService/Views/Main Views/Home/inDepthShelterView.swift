//
//  inDepthShelterView.swift
//  hurricaneService
//
//  Created by Mayank Tiku on 10/23/24.
//

import SwiftUI

import SwiftUI
import MapKit

struct ShelterDetailView: View {
    let backgroundColor = Color(red: 0.2, green: 0.2, blue: 0.5) // Dark storm blue
    let accentColor = Color(red: 1.0, green: 0.6, blue: 0.0) // Warning orange
    let shelter: Shelter
    @State private var region: MKCoordinateRegion
    
    init(shelter: Shelter) {
        self.shelter = shelter
        let coordinate = CLLocationCoordinate2D(latitude: shelter.latitude, longitude: shelter.longitude)
        _region = State(initialValue: MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 5) {
                    // Map View
                    Map(coordinateRegion: $region, annotationItems: [shelter]) { shelter in
                        MapMarker(coordinate: CLLocationCoordinate2D(
                            latitude: shelter.latitude,
                            longitude: shelter.longitude
                        ))
                    }
                    .frame(height: 200)
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    
                    VStack(spacing: 24) {
                        // Header Section
                        VStack(spacing: 8) {
                            Text(shelter.name)
                                .font(.custom("ProductSans-Bold", size: 24))
                                .foregroundColor(.white)
                            
                            Text(shelter.organization)
                                .font(.custom("ProductSans-Regular", size: 16))
                                .foregroundColor(accentColor)
                        }
                        
                        // Capacity Information
                        HStack(spacing: 20) {
                            CapacityCard(
                                title: "Evacuation",
                                capacity: shelter.evacuationCap,
                                iconName: "figure.walk",
                                color: accentColor
                            )
                            
                            CapacityCard(
                                title: "Post-Storm",
                                capacity: shelter.postCap,
                                iconName: "house.fill",
                                color: accentColor
                            )
                        }
                        
                        // Address Section
                        InfoSection(title: "Location") {
                            VStack(alignment: .leading, spacing: 8) {
                                AddressRow(text: shelter.address)
                                AddressRow(text: "\(shelter.city), \(shelter.state) \(shelter.zipCode)")
                                
                                Button(action: {
                                    openInMaps()
                                }) {
                                    Text("Get Directions")
                                        .font(.custom("ProductSans-Bold", size: 16))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(accentColor)
                                        .cornerRadius(12)
                                }
                            }
                        }
                        
                        // Supplies Section
                        InfoSection(title: "Available Supplies") {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 16) {
                                ForEach(Array(shelter.supplies.sorted(by: { $0.key < $1.key })), id: \.key) { item, quantity in
                                    SupplyCard(
                                        type: item,
                                        quantity: quantity,
                                        accentColor: accentColor
                                    )
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(shelter.name)
        .navigationBarTitleTextColor(.white)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func openInMaps() {
        let coordinate = CLLocationCoordinate2D(latitude: shelter.latitude, longitude: shelter.longitude)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = shelter.name
        mapItem.openInMaps(launchOptions: nil)
    }
}

struct CapacityCard: View {
    let title: String
    let capacity: Int
    let iconName: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: iconName)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text("\(capacity)")
                .font(.custom("ProductSans-Bold", size: 20))
                .foregroundColor(.white)
            
            Text(title)
                .font(.custom("ProductSans-Regular", size: 14))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(red: 0.3, green: 0.3, blue: 0.6))
        .cornerRadius(12)
    }
}

struct InfoSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.custom("ProductSans-Bold", size: 18))
                .foregroundColor(.white)
            
            content
                .padding()
                .background(Color(red: 0.3, green: 0.3, blue: 0.6))
                .cornerRadius(12)
        }
    }
}

struct AddressRow: View {
    let text: String
    
    var body: some View {
        HStack {
            Text(text)
                .font(.custom("ProductSans-Regular", size: 16))
                .foregroundColor(.white)
            Spacer()
        }
    }
}

struct SupplyCard: View {
    let type: String
    let quantity: Int
    let accentColor: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: iconName(for: type))
                .font(.system(size: 24))
                .foregroundColor(colorForQuantity(quantity))
            
            Text("\(quantity)")
                .font(.custom("ProductSans-Bold", size: 18))
                .foregroundColor(.white)
            
            Text(type)
                .font(.custom("ProductSans-Regular", size: 14))
                .foregroundColor(.gray)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(red: 0.25, green: 0.25, blue: 0.55))
        .cornerRadius(12)
    }
    
    func iconName(for type: String) -> String {
        switch type.lowercased() {
        case "water": return "drop.fill"
        case "food": return "fork.knife"
        case "beds": return "bed.double.fill"
        case "medical": return "cross.case.fill"
        case "blankets": return "square.fill"
        default: return "cube.fill"
        }
    }
    
    func colorForQuantity(_ quantity: Int) -> Color {
        switch quantity {
        case 0...50: return .red
        case 51...150: return accentColor
        case 151...300: return .yellow
        default: return .green
        }
    }
}

struct ShelterDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ShelterDetailView(shelter: Shelter(
                id: "1",
                name: "City Hall Shelter",
                latitude: 29.7604,
                longitude: -95.3698,
                supplies: [
                    "Water": 500,
                    "Food": 300,
                    "Beds": 100,
                    "Medical": 50,
                    "Blankets": 200
                ],
                organization: "Red Cross",
                address: "901 Bagby St",
                city: "Houston",
                state: "TX",
                zipCode: "77002",
                evacuationCap: 500,
                postCap: 300
            ))
        }
    }
}
