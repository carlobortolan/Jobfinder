//
//  ExploreView.swift
//  mobile
//
//  Created by cb on 16.08.23.
//
//  Describes the search view
//  ==> GET /jobs
//

import SwiftUI

struct ExploreView: View {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager

    @State private var searchText = "searchtest"
    @State private var selectedJobType = "Retail"
    @State private var selectedSortBy = "date_desc"
    @State private var jobs: [Job] = []

    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(searchText: $searchText)
                JobListView(jobs: $jobs)

                Spacer()
            }
            .navigationTitle("Explore")
            .onAppear {
                fetchJobs(iteration: 0)
            }
        }
    }

    func fetchJobs(iteration: Int) {
        if let accessToken = authenticationManager.getAccessToken() {
            APIManager.queryJobs(query: searchText, jobType: selectedJobType, sortBy: selectedSortBy, accessToken: accessToken) { result in
                switch result {
                case .success(let jobs):
                    DispatchQueue.main.async {
                        self.jobs = jobs
                        self.errorHandlingManager.errorMessage = nil
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        if iteration == 0 {
                            if case .authenticationError = error {
                                // Authentication error (e.g., access token invalid)
                                // Refresh the access token and retry the request
                                authenticationManager.fetchAccessToken()
                                self.fetchJobs(iteration: 1)
                            } else {
                                // Handle other errors
                                self.errorHandlingManager.errorMessage = error.localizedDescription
                            }
                        } else {
                            self.authenticationManager.isAuthenticated = false
                            self.errorHandlingManager.errorMessage = "Tokens expired. Log in to refresh tokens."
                        }
                        
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
