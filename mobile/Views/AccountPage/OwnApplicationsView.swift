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

    @State var ownApplications: [Application] = []
    @State var isLoading = false

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Your Applications").font(.largeTitle)) {
                    if ownApplications.isEmpty && !isLoading {
                        Text("No applications yet.")
                    } else {
                        ForEach(ownApplications, id: \.jobId) { application in
                            Text(application.applicationText)
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .onAppear {
                loadOwnApplications(iteration: 0)
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

    func loadOwnApplications(iteration: Int) {
        print("Iteration \(iteration)")
        isLoading = true
        if let accessToken = authenticationManager.getAccessToken() {
            APIManager.fetchOwnApplications(accessToken: accessToken) { result in
                switch result {
                case .success(let applicationsResponse):
                    DispatchQueue.main.async {
                        print("case .success")
                        self.ownApplications = applicationsResponse.applications
                        self.errorHandlingManager.errorMessage = nil
                        isLoading = false
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        print("case .failure, iteration: \(iteration)")
                        if iteration == 0 {
                            if case .authenticationError = error {
                                print("case .authenticationError")
                                // Authentication error (e.g., access token invalid)
                                // Refresh the access token and retry the request
                                self.authenticationManager.requestAccessToken() { accessTokenSuccess in
                                    if accessTokenSuccess{
                                        self.loadOwnApplications(iteration: 1)
                                    } else {
                                        self.errorHandlingManager.errorMessage = error.localizedDescription
                                    }
                                }
                            } else {
                                print("case .else")
                                // Handle other errors
                                self.errorHandlingManager.errorMessage = error.localizedDescription
                            }
                        } else {
                            self.authenticationManager.isAuthenticated = false
                            self.errorHandlingManager.errorMessage = "Tokens expired. Log in to refresh tokens."
                        }
                        isLoading = false
                    }
                }
            }
        }
    }
    
    struct OwnApplicationsView_Previews: PreviewProvider {
        static var previews: some View {
            let errorHandlingManager = ErrorHandlingManager()
            let authenticationManager = AuthenticationManager(errorHandlingManager: errorHandlingManager)
            let ownApplications = Application.generateRandomApplications().applications
            
            return OwnApplicationsView(ownApplications: ownApplications)
                .environmentObject(errorHandlingManager)
                .environmentObject(authenticationManager)
        }
    }
}
