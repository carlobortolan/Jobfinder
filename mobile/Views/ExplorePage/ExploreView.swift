//
//  ExploreView.swift
//  mobile
//
//  Created by cb on 16.08.23.
//
//  Describes the search view
//  ==> GET /jobs
//

import Foundation
import SwiftUI

struct ExploreView: View {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager

    @State private var searchText = "searchtest"
    @State private var selectedJobType = ""
    @State private var selectedSortBy = ""
    @State private var jobs: [Job] = []
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(searchText: $searchText) {
                    fetchJobs(iteration: 0)
                }
                FilterAndSortView(selectedJobType: $selectedJobType, selectedSortBy: $selectedSortBy, isLoading: $isLoading) {
                    fetchJobs(iteration: 0)
                }
                Spacer()
                if isLoading {
                    ProgressView()
                } else {
                    JobListView(jobs: $jobs)
                    Spacer()
                }
                
            }
            .onAppear {
                fetchJobs(iteration: 0)
            }
            .navigationBarHidden(true)
        }
        .padding()
    }

    func fetchJobs(iteration: Int) {
        print("Iteration \(iteration)")
        isLoading = true
        if let accessToken = authenticationManager.getAccessToken() {
            APIManager.queryJobs(query: searchText, jobType: selectedJobType, sortBy: selectedSortBy, accessToken: accessToken) { result in
                switch result {
                case .success(let jobs):
                    DispatchQueue.main.async {
                        print("case .success")
                        self.jobs = jobs
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
                                
                                self.fetchJobs(iteration: 1)
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
    }}

struct Previews_ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        let errorHandlingManager = ErrorHandlingManager()
        let authenticationManager = AuthenticationManager(errorHandlingManager: errorHandlingManager)

        ExploreView().environmentObject(errorHandlingManager).environmentObject(authenticationManager)
    }
}
