//
//  OwnJobsView.swift
//  mobile
//
//  Created by cb on 06.09.23.
//

import SwiftUI

struct OwnJobsView: View {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager

    @State var ownJobs: [Job] = []
    @State var isLoading = false

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Your Jobs").font(.largeTitle)) {
                    if ownJobs.isEmpty && !isLoading {
                        Text("No jobs created yet.")
                    } else {
                        ForEach(ownJobs, id: \.jobId) { job in
                            Text(job.title)
                            Text(job.position)
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .onAppear {
                loadOwnJobs(iteration: 0)
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

    func loadOwnJobs(iteration: Int) {
        print("Iteration \(iteration)")
        isLoading = true
        if let accessToken = authenticationManager.getAccessToken() {
            APIManager.fetchOwnJobs(accessToken: accessToken) { result in
                switch result {
                case .success(let jobsResponse):
                    DispatchQueue.main.async {
                        print("case .success")
                        self.ownJobs = jobsResponse.jobs
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
                                        self.loadOwnJobs(iteration: 1)
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
}
