import SwiftUI
import MapKit

struct Shelter: Identifiable {
    let id = UUID()
    let name: String
    let location: CLLocation
    let distance: Double // in miles
    let supplies: [String: Int]
}

struct NearbySheletersView: View {
    let backgroundColor = Color(red: 0.2, green: 0.2, blue: 0.5) // Dark storm blue
    let accentColor = Color(red: 1.0, green: 0.6, blue: 0.0) // Warning orange
    
    @State private var shelters: [Shelter] = [
        Shelter(name: "City Hall", location: CLLocation(latitude: 29.7604, longitude: -95.3698), distance: 2.3, supplies: ["Water": 500, "Food": 300, "Beds": 100]),
        Shelter(name: "Community Center", location: CLLocation(latitude: 29.7522, longitude: -95.3524), distance: 3.7, supplies: ["Water": 300, "Food": 200, "Beds": 75]),
        Shelter(name: "High School Gym", location: CLLocation(latitude: 29.7707, longitude: -95.3855), distance: 5.1, supplies: ["Water": 700, "Food": 500, "Beds": 150])
    ]
    var body: some View {
//        List(shelters) { shelter in
//            ShelterRow(shelter: shelter, accentColor: accentColor)
//                .listRowBackground(Color.lightPurp)
//        }
        ScrollView {
            ForEach(shelters) { shelter in
                ShelterRow(shelter: shelter, accentColor: accentColor)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 5)
            }
        }
        .background(Color.darkPurp)
        .scrollContentBackground(.hidden)
    }
}

struct ShelterRow: View {
    let shelter: Shelter
    let accentColor: Color
    
    var body: some View {
        ZStack {
//            RoundedRectangle(cornerRadius: 10)
//                .padding(.horizontal, 30)
//                .padding(.vertical, 15)
//                .foregroundStyle(Color.lightPurp)
            VStack(alignment: .leading, spacing: 10) {
                Text(shelter.name)
                    .font(.custom("ProductSans-Bold", size: 18))
                    .foregroundColor(.white)
                
                HStack {
                    Image(systemName: "location.circle.fill")
                        .foregroundColor(accentColor)
                    Text(String(format: "%.1f miles away", shelter.distance))
                        .font(.custom("ProductSans-Regular", size: 14))
                        .foregroundColor(.white)
                }
                
                HStack {
                    ForEach(shelter.supplies.sorted(by: { $0.key < $1.key }), id: \.key) { item, quantity in
                        SupplyIndicator(item: item, quantity: quantity, accentColor: accentColor)
                    }
                }
                
                Button(action: {
                    openInMaps(coordinate: shelter.location, name: shelter.name)
                }) {
                    Text("Open in Maps")
                        .font(.custom("ProductSans-Bold", size: 14))
                        .padding(8)
                        .background(accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 40)
            .background {
                Color.lightPurp
                    .cornerRadius(16)
            }
        }
    }
    
    func openInMaps(coordinate: CLLocation, name: String) {
        let placemark = MKPlacemark(coordinate: coordinate.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = name
        mapItem.openInMaps(launchOptions: nil)
    }
}

struct SupplyIndicator: View {
    let item: String
    let quantity: Int
    let accentColor: Color
    
    var body: some View {
        VStack {
            Image(systemName: iconName(for: item))
                .foregroundColor(colorForQuantity(quantity))
            Text("\(quantity)")
                .font(.custom("ProductSans-Regular", size: 12))
                .foregroundColor(.white)
            Text(item)
                .font(.custom("ProductSans-Regular", size: 10))
                .foregroundColor(.white)
        }
        .frame(width: 60)
    }
    
    func iconName(for item: String) -> String {
        switch item.lowercased() {
        case "water": return "drop.fill"
        case "food": return "fork.knife"
        case "beds": return "bed.double.fill"
        default: return "cube.fill"
        }
    }
    
    func colorForQuantity(_ quantity: Int) -> Color {
        switch quantity {
        case 0...100: return .red
        case 101...300: return accentColor
        case 301...500: return .yellow
        default: return .green
        }
    }
}

#Preview {
    NearbySheletersView()
}
