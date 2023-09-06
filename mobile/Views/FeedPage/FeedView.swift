//
//  FeedView.swift
//  mobile
//
//  Created by cb on 16.08.23.
//
//  Describes the feed with all jobs, reloads after 20 jobs
//  ==> GET /jobs
//

import Foundation
import SwiftUI

struct FeedView: View {
    @EnvironmentObject var errorHandlingManager: ErrorHandlingManager
    @EnvironmentObject var authenticationManager: AuthenticationManager

    @State private var page = 0
    @State private var latitude = Float(1.0)
    @State private var longitude = Float(1.0)
    @State private var jobs: [Job] = JobModel.generateRandomFeedResponse().feed
    @State private var isLoading = false
    @State private var shouldLoadMore = true

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        JobListView(jobs: $jobs)
                            .onAppear {
                                if shouldLoadMore {
                                    page += 1
                                    loadFeed(iteration: 0, page: page)
                                }
                            }
                    }
                }
                Spacer()
            }
            .navigationBarHidden(true)
        }
        .padding()
//        .onAppear {
//            loadFeed(iteration: 0, page: page)
//        }
    }

    func loadFeed(iteration: Int, page: Int) {
        // TODO: Remove max. feed requests per session once S3 is set up
        if page <= 4 {
        print("Iteration \(iteration)")
        isLoading = true
        if let accessToken = authenticationManager.getAccessToken() {
            APIManager.fetchFeed(longitude: longitude, latitude: latitude, page: page, accessToken: accessToken) { result in
                switch result {
                case .success(let jobs):
                    DispatchQueue.main.async {
                        print("case .success")
                        self.jobs += jobs
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
                                
                                self.loadFeed(iteration: 1, page: page)
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
}
