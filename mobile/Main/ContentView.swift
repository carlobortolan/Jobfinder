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
    @EnvironmentObject var jobManager: JobManager
    @EnvironmentObject var applicationManager: ApplicationManager
    @State var isLoadingApp = true
    var body: some View {
        Group {
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
        let jobManager = JobManager(authenticationManager: authenticationManager, errorHandlingManager: errorHandlingManager)
        let applicationManager = ApplicationManager(authenticationManager: authenticationManager, errorHandlingManager: errorHandlingManager)

        ContentView()
            .environmentObject(errorHandlingManager).environmentObject(authenticationManager).environmentObject(jobManager).environmentObject(applicationManager)}
}
