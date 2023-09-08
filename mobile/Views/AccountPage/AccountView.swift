//
//  StartView.swift
//  mobile
//
//  Created by cb on 15.08.23.
//
// ==> GET /user
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var jobManager: JobManager
    @EnvironmentObject var applicationManager: ApplicationManager

    @State private var selectedTab: Tab = .profile
    @State private var isSettingsPresented = false
    
    enum Tab {
        case profile, preferences, ownJobs, ownApplications
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                AccountInfo()
                    .padding()
                    .frame(height: 175.0)
                
                Picker("Select Tab", selection: $selectedTab) {
                    Text("About").tag(Tab.profile)
                    Text("Preferences").tag(Tab.preferences)
                    Text("Jobs").tag(Tab.ownJobs)
                    Text("Applications").tag(Tab.ownApplications)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                Divider()
                
                tabView.frame(maxHeight: .infinity)
            }
            .navigationBarItems(trailing: Button("Log Out") {
                authenticationManager.signOut()
            })
            .navigationBarItems(leading: Button("Settings") {
                isSettingsPresented.toggle()
            })
            .sheet(isPresented: $isSettingsPresented) {
                NavigationView {
                    SettingsView()
                        .navigationBarItems(trailing: Button("Close") {
                            isSettingsPresented.toggle()
                        })
                        .navigationBarTitle("Settings", displayMode: .inline)
                }
                .modifier(ErrorViewModifier())
            }
        }
    }
    
    @ViewBuilder
    private var tabView: some View {
        switch selectedTab {
        case .profile:
            ProfileView()
        case .preferences:
            PreferencesView()
        case .ownJobs:
            OwnJobsView()
        case .ownApplications:
            OwnApplicationsView()
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        let errorHandlingManager = ErrorHandlingManager()
        let authenticationManager = AuthenticationManager(errorHandlingManager: errorHandlingManager)
        
        return AccountView()
            .environmentObject(errorHandlingManager)
            .environmentObject(authenticationManager)
    }
}
