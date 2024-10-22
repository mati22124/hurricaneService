//
//  SettingsView 2.swift
//  hurricaneService
//
//  Created by Mayank Tiku on 10/22/24.
//


import SwiftUI

struct SettingsView: View {
    let backgroundColor = Color(red: 0.2, green: 0.2, blue: 0.5) // Dark storm blue
    let accentColor = Color(red: 1.0, green: 0.6, blue: 0.0) // Warning orange
    
    @State private var notificationsEnabled = true
    @State private var locationEnabled = true
    @State private var showDeleteAccountAlert = false
    
    @StateObject private var viewModel = SettingsViewModel()
    
    @Binding var showLoginView: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                backgroundColor.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Account Section
                        SettingsSectionView(title: "Account") {
                            VStack(spacing: 16) {
                                NavigationLink(destination: Text("Profile Settings")
                                    .foregroundColor(.white)) {
                                    SettingsRowView(
                                        icon: "person.circle.fill",
                                        title: "Edit Profile",
                                        iconColor: accentColor
                                    )
                                }
                                
                                NavigationLink(destination: Text("Notification Settings")
                                    .foregroundColor(.white)) {
                                    SettingsRowView(
                                        icon: "bell.fill",
                                        title: "Notifications",
                                        iconColor: accentColor
                                    )
                                }
                            }
                        }
                        
                        // Preferences Section
                        SettingsSectionView(title: "Preferences") {
                            VStack(spacing: 16) {
                                Toggle(isOn: $notificationsEnabled) {
                                    SettingsRowView(
                                        icon: "bell.badge.fill",
                                        title: "Emergency Alerts",
                                        iconColor: accentColor
                                    )
                                }
                                .tint(accentColor)
                                
                                Toggle(isOn: $locationEnabled) {
                                    SettingsRowView(
                                        icon: "location.fill",
                                        title: "Location Services",
                                        iconColor: accentColor
                                    )
                                }
                                .tint(accentColor)
                            }
                        }
                        
                        // Danger Zone Section
                        SettingsSectionView(title: "Account Actions") {
                            VStack(spacing: 16) {
                                Button(action: {
                                    do {
                                        try viewModel.logOut()
                                        showLoginView = true
                                    } catch {
                                        print("Error logging out: \(error)")
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: "rectangle.portrait.and.arrow.right")
                                            .foregroundColor(.white)
                                        Text("Log Out")
                                            .foregroundColor(.white)
                                            .font(.custom("ProductSans-Bold", size: 16))
                                        Spacer()
                                    }
                                    .padding()
                                    .background(accentColor)
                                    .cornerRadius(12)
                                }
                                
                                Button(action: {
                                    showDeleteAccountAlert = true
                                }) {
                                    HStack {
                                        Image(systemName: "trash.fill")
                                            .foregroundColor(.white)
                                        Text("Delete Account")
                                            .foregroundColor(.white)
                                            .font(.custom("ProductSans-Bold", size: 16))
                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.red.opacity(0.8))
                                    .cornerRadius(12)
                                }
                            }
                        }
                        
                        // App Info Section
                        SettingsSectionView(title: "About") {
                            VStack(spacing: 16) {
                                SettingsInfoRow(title: "Version", value: "1.0.0")
                                SettingsInfoRow(title: "Build", value: "2024.1")
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Delete Account", isPresented: $showDeleteAccountAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    Task {
                        do {
                            try await viewModel.deleteAcc()
                            showLoginView = true
                        } catch {
                            print("Error deleting account: \(error)")
                        }
                    }
                }
            } message: {
                Text("Are you sure you want to delete your account? This action cannot be undone.")
            }
        }
        .accentColor(.white)
    }
}

// MARK: - Supporting Views
struct SettingsSectionView<Content: View>: View {
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
                .padding(.leading, 4)
            
            VStack {
                content
            }
            .padding()
            .background(Color(red: 0.3, green: 0.3, blue: 0.6))
            .cornerRadius(16)
        }
    }
}

struct SettingsRowView: View {
    let icon: String
    let title: String
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(iconColor)
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(.custom("ProductSans-Regular", size: 16))
                .foregroundColor(.white)
            
            Spacer()
        }
    }
}

struct SettingsInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.custom("ProductSans-Regular", size: 16))
                .foregroundColor(.white)
            Spacer()
            Text(value)
                .font(.custom("ProductSans-Regular", size: 16))
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    SettingsView(showLoginView: .constant(false))
}
