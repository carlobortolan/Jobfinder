//
//  mobileApp.swift
//  mobile
//
//  Created by cb on 15.08.23.
//

import SwiftUI

@main
struct mobileApp: App {
    var body: some Scene {
        let errorHandlingManager = ErrorHandlingManager()
        let authenticationManager = AuthenticationManager(errorHandlingManager: errorHandlingManager)
        
        WindowGroup {
            NavigationView {
                if authenticationManager.isAuthenticated {
                    // User is authenticated, show the main application view
                    ContentView().environmentObject(errorHandlingManager).environmentObject(authenticationManager)
                } else {
                    // User is not authenticated, show the login view
                    ContentView().environmentObject(errorHandlingManager).environmentObject(authenticationManager)
                }
            }
        }
    }
}
