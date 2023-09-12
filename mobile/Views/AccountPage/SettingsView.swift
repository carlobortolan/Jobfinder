//
//  SettingsView.swift
//  mobile
//
//  Created by cb on 08.09.23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var jobManager: JobManager
    @EnvironmentObject var applicationManager: ApplicationManager

    enum Tab {
        case updateUser, updateUserPreferences, aboutApp
    }
    
    @State private var selectedTab: Tab = .updateUser
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack(spacing: 30) {
                    Spacer()
                    
                    Button(action: {
                        selectedTab = .updateUser
                    }) {
                        Image(systemName: "person")
                            .font(.system(size: 20))
                            .foregroundColor(selectedTab == .updateUser ? .blue : .gray)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        selectedTab = .updateUserPreferences
                    }) {
                        Image(systemName: "gear")
                            .font(.system(size: 20))
                            .foregroundColor(selectedTab == .updateUserPreferences ? .blue : .gray)
                    }
                    
                    Spacer()
                 
                    Button(action: {
                        selectedTab = .aboutApp
                    }) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 20))
                            .foregroundColor(selectedTab == .aboutApp ? .blue : .gray)
                    }
                    
                    Spacer()
                }
                .padding(.top, 10)
                .background(Color(UIColor.systemBackground))
                
                Divider()
                
                tabView
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
    }
    
    @ViewBuilder
    private var tabView: some View {
        switch selectedTab {
        case .aboutApp:
            AppInfoView()
        case .updateUser:
            UpdateUserView(user: $authenticationManager.current)
        case .updateUserPreferences:
            UpdateUserPreferencesView()
        }
    }
}
