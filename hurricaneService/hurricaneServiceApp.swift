//
//  hurricaneServiceApp.swift
//  hurricaneService
//
//  Created by Mayank Tiku on 10/8/24.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct hurricaneServiceApp: App {
    //app delegate firebase setup.
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
