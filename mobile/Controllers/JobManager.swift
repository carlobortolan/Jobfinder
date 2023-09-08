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
    
    init(authenticationManager: AuthenticationManager,
         errorHandlingManager: ErrorHandlingManager) {
        self.authenticationManager = authenticationManager
        self.errorHandlingManager = errorHandlingManager
        self._ownJobs = Published(wrappedValue: [])
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
                        completion() // Call the completion closure when loading is complete
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
                                        self.loadOwnJobs(iteration: 1, completion: completion) // Call with completion closure
                                    } else {
                                        self.errorHandlingManager.errorMessage = error.localizedDescription
                                        completion() // Call the completion closure even on failure
                                    }
                                }
                            } else {
                                print("case .else")
                                // Handle other errors
                                self.errorHandlingManager.errorMessage = error.localizedDescription
                                completion() // Call the completion closure even on failure
                            }
                        } else {
                            self.authenticationManager.isAuthenticated = false
                            self.errorHandlingManager.errorMessage = "Tokens expired. Log in to refresh tokens."
                            completion() // Call the completion closure when loading is complete
                        }
                    }
                }
            }
        }
    }
}
