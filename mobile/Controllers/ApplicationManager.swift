//
//  ApplicationManager.swift
//  mobile
//
//  Created by cb on 08.09.23.
//

import SwiftUI

class ApplicationManager: ObservableObject {
    private var authenticationManager: AuthenticationManager
    private var errorHandlingManager: ErrorHandlingManager
    
    @Published var ownApplications: [Application]
    
    init(authenticationManager: AuthenticationManager,
         errorHandlingManager: ErrorHandlingManager) {
        self.authenticationManager = authenticationManager
        self.errorHandlingManager = errorHandlingManager
        self._ownApplications = Published(wrappedValue: [])
    }
    
    func loadOwnApplications(iteration: Int, completion: @escaping () -> Void) {
        print("Iteration \(iteration)")
        if let accessToken = authenticationManager.getAccessToken() {
            APIManager.fetchOwnApplications(accessToken: accessToken) { result in
                switch result {
                case .success(let applicationsResponse):
                    DispatchQueue.main.async {
                        print("case .success")
                        self.ownApplications = applicationsResponse.applications
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
                                        self.loadOwnApplications(iteration: 1, completion: completion) // Call with completion closure
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
