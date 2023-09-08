//
//  SettingsView.swift
//  mobile
//
//  Created by cb on 08.09.23.
//

import SwiftUI

struct SettingsView: View {
    @State private var selectedTab = 0

    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    
    var body: some View {
        TabView(selection: $selectedTab) {
            AppInfoView()
                .tag(0)
                .tabItem {
                    Label("About App", systemImage: "info.circle")
                        .font(.system(size: 30))
                }
            
            UpdateUserView()
                .tag(1)
                .tabItem {
                    Label("Update User", systemImage: "person.circle")
                        .font(.system(size: 30))
                }
            
            UpdateUserPreferencesView()
                .tag(2)
                .tabItem {
                    Label("Update Preferences", systemImage: "gearshape.fill")
                        .font(.system(size: 30))
                }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
