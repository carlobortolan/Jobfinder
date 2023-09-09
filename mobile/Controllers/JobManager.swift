//
//  JobManager.swift
//  mobile
//
//  Created by cb on 08.09.23.
//

import SwiftUI

class JobManager: ObservableObject {
    private var authenticationManager: AuthenticationManager
    private var errorHandlingManager: ErrorHandlingManager
    
    @Published var ownJobs: [Job]
    @Published var upcomingJobs: [Job]
    @Published var nearbyJobs: [Job]
    
    init(authenticationManager: AuthenticationManager,
         errorHandlingManager: ErrorHandlingManager) {
        self.authenticationManager = authenticationManager
        self.errorHandlingManager = errorHandlingManager
        self._ownJobs = Published(wrappedValue: [])
        self._upcomingJobs = Published(wrappedValue: JobModel.generateRandomJobsResponse().jobs)
        self._nearbyJobs = Published(wrappedValue: [])
        
        self.loadOwnJobs(iteration: 0) {}
        self.loadUpcomingJobs(iteration: 0) {}
    }
    
    func loadOwnJobs(iteration: Int, completion: @escaping () -> Void) {
        print("Iteration \(iteration)")
        if let accessToken = authenticationManager.getAccessToken() {
            APIManager.fetchOwnJobs(accessToken: accessToken) { result in
                switch result {
                case .success(let jobsResponse):
                    DispatchQueue.main.async {
                        print("case .success")
                        self.ownJobs = jobsResponse.jobs
                        self.errorHandlingManager.errorMessage = nil
                        completion()
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
                                    if accessTokenSuccess {
                                        self.loadOwnJobs(iteration: 1, completion: completion)
                                    } else {
                                        self.errorHandlingManager.errorMessage = error.localizedDescription
                                        completion()
                                    }
                                }
                            } else {
                                print("case .else")
                                self.errorHandlingManager.errorMessage = error.localizedDescription
                                completion()
                            }
                        } else {
                            self.authenticationManager.isAuthenticated = false
                            self.errorHandlingManager.errorMessage = "Tokens expired. Log in to refresh tokens."
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    func loadUpcomingJobs(iteration: Int, completion: @escaping () -> Void) {
        print("Iteration \(iteration)")
        if let accessToken = authenticationManager.getAccessToken() {
            APIManager.fetchUpcomingJobs(accessToken: accessToken) { result in
                switch result {
                case .success(let jobsResponse):
                    DispatchQueue.main.async {
                        print("case .success")
                        self.upcomingJobs = jobsResponse.jobs
                        self.errorHandlingManager.errorMessage = nil
                        completion()
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
                                    if accessTokenSuccess {
                                        self.loadUpcomingJobs(iteration: 1, completion: completion)
                                    } else {
                                        self.errorHandlingManager.errorMessage = error.localizedDescription
                                        completion()
                                    }
                                }
                            } else {
                                print("case .else")
                                self.errorHandlingManager.errorMessage = error.localizedDescription
                                completion()
                            }
                        } else {
                            self.authenticationManager.isAuthenticated = false
                            self.errorHandlingManager.errorMessage = "Tokens expired. Log in to refresh tokens."
                            completion()
                        }
                    }
                }
            }
        }
    }

    func loadNearbyJobs(iteration: Int, longitude: Double, latitude: Double, completion: @escaping () -> Void) {
        print("Iteration \(iteration)")
        if let accessToken = authenticationManager.getAccessToken() {
            APIManager.fetchNearbyJobs(accessToken: accessToken, longitude: longitude, latitude: latitude) { result in
                switch result {
                case .success(let jobsResponse):
                    DispatchQueue.main.async {
                        print("case .success")
                        self.nearbyJobs = jobsResponse.jobs
                        self.errorHandlingManager.errorMessage = nil
                        completion()
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
                                    if accessTokenSuccess {
                                        self.loadNearbyJobs(iteration: 1, longitude: longitude, latitude: latitude, completion: completion)
                                    } else {
                                        self.errorHandlingManager.errorMessage = error.localizedDescription
                                        completion()
                                    }
                                }
                            } else {
                                print("case .else")
                                self.errorHandlingManager.errorMessage = error.localizedDescription
                                completion()
                            }
                        } else {
                            self.authenticationManager.isAuthenticated = false
                            self.errorHandlingManager.errorMessage = "Tokens expired. Log in to refresh tokens."
                            completion()
                        }
                    }
                }
            }
        }
    }

}
