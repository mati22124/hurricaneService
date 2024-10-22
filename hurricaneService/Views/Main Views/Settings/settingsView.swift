//
//  settingsView.swift
//  hurricaneService
//
//  Created by Mayank Tiku on 10/17/24.
//

import SwiftUI

struct settingsView: View {
    
    
    // ViewModel
    @StateObject private var settingsViewModel = SettingsViewModel()
    
    @Binding var showLoginView: Bool

    var body: some View {
        VStack {
            
            HStack {
                profilePhotoView()
                
                profileNameView(text: "Suraj Nistala")
                
            }
            .padding()
            
            HStack {
                settingsButton(text: "Logout", action: {
                    try? settingsViewModel.logOut()
                    showLoginView = true
                })
                
                settingsButton(text: "Delete Account", action: {})
            }
           
                
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.darkPurp)
        
        
        /*
        VStack {
            if let user = settingsViewModel.user {
                Text("Name: "+user.email)
                Button {
                    try? settingsViewModel.logOut()
                    showLoginView = true
                } label: {
                    Text("Sign Out")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.darkPurp)
        .task {
            do {
                try await settingsViewModel.loadCurrentUser()
            }catch {
                print("couldn't get user")
            }
            
        }*/
        
        
    }
}





    
    










struct profileNameView: View {
    
    var text: String
    
    
    var body: some View {
        
        
        Text(text)
            .foregroundColor(.white)
            .font(.custom("OpenSansRoman-Bold", size: 24))
        
        
    }
}


    
    
struct profilePhotoView: View {
    
    var body: some View {
        ZStack{
            Circle()
                .foregroundColor(.white)
                .frame(width:140,height: 140)
                .shadow(radius: 4,y:3)

                
            ProgressView()
                .frame(width:180,height:180)
                .clipShape(Circle())
                .shadow(radius: 4,y:4)
                    
            
        }
    }
}
    
    
    
    
    
    
    
    
    
struct settingsButton: View {
    var text: String
    
    var color: Color = .red
    
    var action: () -> Void
    
    var body: some View {
        
        Button(action: action, label: {
            ZStack {
                
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color.accentOrange)
                    .frame(width: 112,height:33)
                    .shadow(radius:4,x:2,y:9)
                
                Text(text)
                    .foregroundColor(.white)
                    .font(.custom("OpenSansRoman-Bold", size: 12))
                
                
            }
            .padding()
        })
        
      
     
    }
}

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    






#Preview {
    settingsView(showLoginView: .constant(false))
}
