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
                        Text("Interests: \(preferences.interests ?? "n.a.")")
                        Text("Experience: \(preferences.experience ?? "n.a.")")
                        Text("Degree: \(preferences.degree ?? "n.a.")")
                        Text("Number of Jobs Done: \(preferences.numJobsDone)")
                        Text("Gender: \(preferences.gender ?? "Not specified")")
                        Text("Spontaneity: \(String(format: "%.1f", preferences.spontaneity ?? 0))")
                        Text("Key Skills: \(preferences.keySkills ?? "n.a.")")
                        Text("Salary Range: \(String(format: "%.1f - %.1f", preferences.salaryRange?[0] ?? 0, preferences.salaryRange?[1] ?? 0))")
                        Text("CV URL: \(preferences.cvURL ?? "n.a.")")
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .onAppear {
                loadPreferences(iteration: 0)
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
                                self.authenticationManager.requestAccessToken() { accessTokenSuccess in
                                    if accessTokenSuccess{
                                        self.loadPreferences(iteration: 1)
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
    
    struct PreferencesView_Previews: PreviewProvider {
        static var previews: some View {
            let errorHandlingManager = ErrorHandlingManager()
            let authenticationManager = AuthenticationManager(errorHandlingManager: errorHandlingManager)
            let preferences = Preferences.generateRandomPreference()
            
            return PreferencesView(preferences: preferences)
                .environmentObject(errorHandlingManager)
                .environmentObject(authenticationManager)
        }
    }
}
