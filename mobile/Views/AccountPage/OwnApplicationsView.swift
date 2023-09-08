//
//  OwnApplicationsView.swift
//  mobile
//
//  Created by cb on 06.09.23.
//

import SwiftUI

struct OwnApplicationsView: View {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @EnvironmentObject var jobManager: JobManager
    @EnvironmentObject var applicationManager: ApplicationManager

//    @State var ownApplications: [Application] = []
    @State var isLoading = false

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Your Applications").font(.largeTitle)) {
                    if applicationManager.ownApplications.isEmpty && !isLoading {
                        Text("No applications yet.")
                    } else {
                        ForEach(applicationManager.ownApplications, id: \.jobId) { application in
                            Text(application.applicationText)
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .onAppear {
                isLoading = true
                print("STARTED AOO")
                applicationManager.loadOwnApplications(iteration: 0) {
                    isLoading = false
                }
            }
            .overlay(
                Group {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .scaleEffect(1.5, anchor: .center)
                    }
                }
            )
        }
    }

    
    struct OwnApplicationsView_Previews: PreviewProvider {
        static var previews: some View {
            let errorHandlingManager = ErrorHandlingManager()
            let authenticationManager = AuthenticationManager(errorHandlingManager: errorHandlingManager)
            
            return OwnApplicationsView()
                .environmentObject(errorHandlingManager)
                .environmentObject(authenticationManager)
        }
    }
}
