//
//  SwiftUIView.swift
//  mobile
//
//  Created by cb on 16.08.23.
//

import SwiftUI

struct TabBarView: View {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var jobManager: JobManager
    @EnvironmentObject var applicationManager: ApplicationManager

    var body: some View {
        TabView {
            StartView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            FeedView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Feed")
                }
            ExploreView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Explore")
                }
            AccountView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Account")
                }
        }
    }
}

struct Previews_TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        let errorHandlingManager = ErrorHandlingManager()
        let authenticationManager = AuthenticationManager(errorHandlingManager: errorHandlingManager)

        TabBarView()            .environmentObject(errorHandlingManager).environmentObject(authenticationManager)

    }
}
