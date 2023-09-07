//
//  PreferencesView.swift
//  mobile
//
//  Created by cb on 06.09.23.
//

import SwiftUI

struct PreferencesView: View {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager

    @State var preferences: Preferences?
    @State var isLoading = false

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Preferences").font(.largeTitle)) {
                    if let preferences = preferences {
                        Text("Interests: \(preferences.interests)")
                        Text("Experience: \(preferences.experience)")
                        Text("Degree: \(preferences.degree)")
                        Text("Number of Jobs Done: \(preferences.numJobsDone)")
                        Text("Gender: \(preferences.gender ?? "Not specified")")
                        Text("Spontaneity: \(String(format: "%.1f", preferences.spontaneity))")
                        Text("Key Skills: \(preferences.keySkills)")
                        Text("Salary Range: \(String(format: "%.1f - %.1f", preferences.salaryRange[0], preferences.salaryRange[1]))")
                        Text("CV URL: \(preferences.cvURL)")
                    } else {
                        Text("Loading...")
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .onAppear {
                loadPreferences(iteration: 0)
            }
        }
    }

    func loadPreferences(iteration: Int) {
        print("Iteration \(iteration)")
        isLoading = true
        if let accessToken = authenticationManager.getAccessToken() {
            APIManager.fetchPreferences(accessToken: accessToken) { result in
                switch result {
                case .success(let preferenceResponse):
                    DispatchQueue.main.async {
                        print("case .success")
                        self.preferences = preferenceResponse.preferences
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
                                self.authenticationManager.fetchAccessToken()
                                
                                self.loadPreferences(iteration: 1)
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
}
