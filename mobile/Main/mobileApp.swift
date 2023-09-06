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
            ContentView()
                .environmentObject(authenticationManager).environmentObject(errorHandlingManager)
        }
    }
}
