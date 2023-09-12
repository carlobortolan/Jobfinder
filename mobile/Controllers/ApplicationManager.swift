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
        
        if let cachedOwnApplicationsJSON = UserDefaults.standard.string(forKey: "cachedOwnApplicationsJSON"),
           let cachedOwnApplications = ApplicationsResponse.fromJSON(cachedOwnApplicationsJSON) {
            self.ownApplications = cachedOwnApplications
        } else {
            self.ownApplications = []
        }
        self.loadOwnApplications(iteration: 0) {}
    }
    
    func hasApplication(forUserId userId: Int, andJobId jobId: Int) -> Bool {
        return ownApplications.contains { application in
            return application.userId == userId && application.jobId == jobId
        }
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
                        if let ownApplications = applicationsResponse.toJSON() {
                            UserDefaults.standard.set(ownApplications, forKey: "cachedOwnApplicationsJSON")
                        }
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
                                        self.loadOwnApplications(iteration: 1, completion: completion)
                                    } else {
                                        self.errorHandlingManager.errorMessage = error.localizedDescription
                                        completion()
                                    }
                                }
                            } else {
                                if case .noContent = error {
                                    DispatchQueue.main.async {
                                        print("case .success")
                                        self.ownApplications = []
                                        UserDefaults.standard.set(self.ownApplications, forKey: "cachedOwnApplicationsJSON")
                                        self.errorHandlingManager.errorMessage = nil
                                        completion()
                                    }
                                } else {
                                    print("case .else")
                                    self.errorHandlingManager.errorMessage = error.localizedDescription
                                    completion()
                                }
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
    
    func loadApplication(iteration: Int, jobId: Int, completion: @escaping (Application?) -> Void) {
        print("Iteration \(iteration)")
        if let accessToken = authenticationManager.getAccessToken() {
            APIManager.fetchApplication(accessToken: accessToken, jobId: jobId) { result in
                switch result {
                case .success(let applicationResponse):
                    DispatchQueue.main.async {
                        print("case .success")
                        self.errorHandlingManager.errorMessage = nil
                        completion(applicationResponse.application.first)
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
                                        self.loadApplication(iteration: 1, jobId: jobId) { application in
                                            completion(application)
                                        }
                                    } else {
                                        self.errorHandlingManager.errorMessage = error.localizedDescription
                                        completion(nil)
                                    }
                                }
                            } else {
                                print("case .else")
                                self.errorHandlingManager.errorMessage = error.localizedDescription
                                completion(nil)
                            }
                        } else {
                            self.authenticationManager.isAuthenticated = false
                            self.errorHandlingManager.errorMessage = "Tokens expired. Log in to refresh tokens."
                            completion(nil)
                        }
                    }
                }
            }
        }
    }
    
    func submitApplication(iteration: Int, jobId: Int, userId: Int, message: String, cv: Data?) {
        print("Iteration \(iteration)")
        let application = Application(jobId: jobId, userId: userId, createdAt: "", updatedAt: "", status: "0", applicationText: message, applicationDocuments: nil, response: nil)
        if let accessToken = authenticationManager.getAccessToken() {
            APIManager.createApplication(accessToken: accessToken, application: application, cv: cv) { tokenResponse in
                switch tokenResponse {
                case .success(let apiResponse):
                    DispatchQueue.main.async {
                        print("case .success \(apiResponse)")
                        self.errorHandlingManager.errorMessage = nil
                        self.ownApplications.append(application)
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
                                        self.submitApplication(iteration: 1, jobId: jobId, userId: userId, message: message, cv: cv)
                                    } else {
                                        self.errorHandlingManager.errorMessage = error.localizedDescription
                                    }
                                }
                            } else {
                                print("case .else")
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
    }
}
