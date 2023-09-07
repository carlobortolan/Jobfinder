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

    @State private var page = 1 // Start with page 1
    @State private var isLoading = false
    @State private var jobs: [Job] = []
    @State private var longitude = Float(1.0)
    @State private var latitude = Float(1.0)

    // Threshold value to determine when the user is near the bottom
    private let nearBottomThreshold: CGFloat = 100

    var body: some View {
        NavigationView {
            // Use a GeometryReader to detect when the user is near the bottom
            GeometryReader { geometry in
                List {
                    JobListView(jobs: $jobs)
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
                .onAppear {
                    if jobs.isEmpty {
                        loadFeed(iteration: 0, page: page)
                    }
                }
                .onAppear(perform: {
                    UITableView.appearance().separatorStyle = .none
                })
                .onAppear {
                    if isNearBottom(offset: geometry.frame(in: .global).maxY, threshold: nearBottomThreshold) {
                        // User is near the bottom, print a message
                        print("User is near the bottom of the feed")
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .padding()
    }

    private func isNearBottom(offset: CGFloat, threshold: CGFloat) -> Bool {
        let scrollViewHeight = UIScreen.main.bounds.height - 100
        return offset > scrollViewHeight - threshold
    }
    
    func loadFeed(iteration: Int, page: Int) {
        // TODO: Remove max. feed requests per session once S3 is set up
        if page <= 4 {
        print("Iteration \(iteration)")
        isLoading = true
        if let accessToken = authenticationManager.getAccessToken() {
            APIManager.fetchFeed(longitude: longitude, latitude: latitude, page: page, accessToken: accessToken) { result in
                switch result {
                case .success(let feedResponse):
                    DispatchQueue.main.async {
                        print("case .success")
                        self.jobs += feedResponse.feed
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
                                        self.loadFeed(iteration: 1, page: page)
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
}
