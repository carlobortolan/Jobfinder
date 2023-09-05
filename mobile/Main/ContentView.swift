//
//  ContentView.swift
//  mobile
//
//  Created by cb on 15.08.23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager

    var body: some View {
        NavigationView {
            if authenticationManager.isAuthenticated {
                TabBarView()
            } else {
                LoginView()
            }
        }.modifier(ErrorViewModifier())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let errorHandlingManager = ErrorHandlingManager()
        let authenticationManager = AuthenticationManager(errorHandlingManager: errorHandlingManager)

        ContentView().environmentObject(errorHandlingManager).environmentObject(authenticationManager)}
}
