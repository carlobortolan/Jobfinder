//
//  mobileApp.swift
//  mobile
//
//  Created by cb on 15.08.23.
//

import SwiftUI

@main
struct mobileApp: App {
    @AppStorage("isAuthenticated") var isAuthenticated = false
    @AppStorage("accessToken") var accessToken: String?
    @AppStorage("refreshToken") var refreshToken: String?

    var body: some Scene {
        WindowGroup {
            NavigationView {
                if isAuthenticated {
                    // User is authenticated, show the main application view
                    ContentView()
                } else {
                    // User is not authenticated, show the login view
                    ContentView()
                }
            }
        }
    }
}
