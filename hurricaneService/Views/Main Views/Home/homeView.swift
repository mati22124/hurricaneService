import SwiftUI
import MapKit

struct NearbySheletersView: View {
    let backgroundColor = Color(red: 0.2, green: 0.2, blue: 0.5) // Dark storm blue
    let accentColor = Color(red: 1.0, green: 0.6, blue: 0.0) // Warning orange
    
    @StateObject var viewModel = homeViewModel()
    @StateObject var locManager = LocationManager()
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.shelters) { shelter in
                ShelterRow(shelter: shelter, accentColor: accentColor, curLoc: locManager.lastKnownLocation)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 5)
                    .environmentObject(viewModel)
            }
        }
        .onAppear() {
            Task {
                do {
                    try await viewModel.getShelters()
                    locManager.checkLocationAuthorization()
                } catch {
                    print("Error fetching shelters: \(error)")
                }
            }
        }
        .background(Color.darkPurp)
        .scrollContentBackground(.hidden)
    }
}

struct ShelterRow: View {
    let shelter: Shelter
    let accentColor: Color
    let curLoc: CLLocation?
    
    @EnvironmentObject var viewModel: homeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(shelter.name)
                .font(.custom("ProductSans-Bold", size: 18))
                .foregroundColor(.white)
            HStack {
                Image(systemName: "location.circle.fill")
                    .foregroundColor(accentColor)
                Text("\(viewModel.findDistance(current: curLoc, shelter: shelter))")
                    .font(.custom("ProductSans-Regular", size: 14))
                    .foregroundColor(.white)
            }
            
            HStack {
                ForEach(shelter.supplies.sorted(by: { $0.key < $1.key }), id: \.key) { item, quantity in
                    SupplyIndicator(item: item, quantity: quantity, accentColor: accentColor)
                }
            }
            
            Button(action: {
                viewModel.openInMaps(coordinate: CLLocation(latitude: shelter.latitude, longitude: shelter.longitude), name: shelter.name)
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
