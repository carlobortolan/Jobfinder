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
        // Create instances of your managers
        let errorHandlingManager = ErrorHandlingManager()
        let authenticationManager = AuthenticationManager(errorHandlingManager: errorHandlingManager)
        
        // Set up the main window group with ContentView
        WindowGroup {
            ContentView()
                .environmentObject(authenticationManager).environmentObject(errorHandlingManager)
        }
    }
}
