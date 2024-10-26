//
//  mainView.swift
//  hurricaneService
//
//  Created by Mayank Tiku on 10/17/24.
//

import SwiftUI

struct mainView: View {
    @Binding var showLoginView: Bool
    
    @State private var selectedTab: Int = 2

    var body: some View {
        VStack {
            // Content area
            switch selectedTab {
                /* tabs to add
                 1. posts
                 2. friends
                 3. home
                 4. map
                 5. settings
                 */
            case 0:
                PostsView()
            case 1:
                StormBuddyChatView()
            case 2:
                NavigationStack {
                    NearbySheletersView()
                        .navigationTitle("Nearby Sheleters")
                        .navigationBarTitleTextColor(.white)
                }
            case 3:
                mapView()
            case 4:
                SettingsView(showLoginView: $showLoginView)
            default:
                Text("idk how u got here but thats impressive")
            }
            
            // Custom capsule-shaped tab bar
            HStack {
                ForEach(0..<5) { index in
                    TabBarItem(imageName: getImageName(for: index),
                               title: getTitle(for: index),
                               isSelected: selectedTab == index,
                               action: { selectedTab = index })
                }
            }
            .padding(8)
            .background(Color(UIColor.systemBackground)) // Add contrasting background
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            .padding(.horizontal)
            .offset(x: 0, y: 12)
        }
        .background(Color.darkPurp)    }
    
    func getImageName(for index: Int) -> String {
        switch index {
        case 0: return "camera.aperture"
        case 1: return "message"
        case 2: return "house.fill"
        case 3: return "map.fill"
        case 4: return "gear"
        default: return ""
        }
    }
    
    func getTitle(for index: Int) -> String {
        switch index {
        case 0: return "Posts"
        case 1: return "Storm Buddy"
        case 2: return "Home"
        case 3: return "Map"
        case 4: return "Settings"
        default: return ""
        }
    }
}

struct TabBarItem: View {
    let imageName: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: imageName)
                    .font(.system(size: 20))
                    .foregroundStyle(isSelected ? .white : .textColo)
                if isSelected {
                    Text(title)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
            }
            .foregroundColor(isSelected ? .white : .gray)
            .padding(.vertical, 10)
            .padding(.horizontal, isSelected ? 16 : 12)
            .background(isSelected ? Color.accentOrange : Color.clear)
            .clipShape(Capsule())
        }
    }
}

#Preview {
    mainView(showLoginView: .constant(false))
}
