//
//  ContentView.swift
//  mobile
//
//  Created by cb on 15.08.23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authenticationManager: AuthenticationManager
    
    var body: some View {
        NavigationView {
            if authenticationManager.isAuthenticated {
                TabBarView()
            } else {
                LoginView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthenticationManager(errorHandlingManager: ErrorHandlingManager()))
    }
}
