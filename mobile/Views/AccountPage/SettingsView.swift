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
                tabView
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        selectedTab = .updateUser
                    }) {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding()
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        selectedTab = .updateUserPreferences
                    }) {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding()
                    }
                    
                    Spacer()
                 
                    Button(action: {
                        selectedTab = .aboutApp
                    }) {
                        Image(systemName: "info.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding()
                    }
                    
                    Spacer()
                }
                .background(Color(UIColor.systemBackground))
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
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let errorHandlingManager = ErrorHandlingManager()
        let authenticationManager = AuthenticationManager(errorHandlingManager: errorHandlingManager)

        SettingsView().environmentObject(errorHandlingManager).environmentObject(authenticationManager)
    }
}
