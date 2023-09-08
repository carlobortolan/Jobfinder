//
//  AuthenticationManager.swift
//  mobile
//
//  Created by cb on 16.08.23.
//

import Foundation
import SwiftUI

class AuthenticationManager: ObservableObject {
    private var errorHandlingManager: ErrorHandlingManager
    
    @AppStorage("isAuthenticated") var isAuthenticated = false
    @Published var password = ""
    @Published var passwordConfirmation = ""
    @Published var current: User

    init(errorHandlingManager: ErrorHandlingManager) {
        self.errorHandlingManager = errorHandlingManager
        
        if let cachedUserJSON = UserDefaults.standard.string(forKey: "cachedUserJSON"),
           let cachedUser = User.fromJSON(cachedUserJSON) {
            self.current = cachedUser
        } else {
            self.current = User()
         }
    }
    
    private func saveRefreshToken(refreshToken: String?) {
        if let refreshToken = refreshToken {
            KeychainManager.saveOrUpdateToken(refreshToken, forKey: "refreshToken")
        }
    }
    
    private func saveAccessToken(accessToken: String?) {
        if let accessToken = accessToken {
            KeychainManager.saveOrUpdateToken(accessToken, forKey: "accessToken")
        }
    }

    private func loadRefreshToken() -> String? {
        return KeychainManager.loadToken(forKey: "refreshToken")
    }

    private func loadAccessToken() -> String? {
        return KeychainManager.loadToken(forKey: "accessToken")
    }
    
    // Fetch tokens and and sign in
    func signIn() {
        // Fetch refresh token
        APIManager.fetchRefreshToken(email: current.email, password: password) { refreshTokenSuccess in
            print("Step: 0")
            switch refreshTokenSuccess {
            case .success(let apiResponse):
                print("Successfully signed in: \(apiResponse.message)")
                print("Step: 1")
                DispatchQueue.main.async {
                    print("Step: 2")
                    self.saveRefreshToken(refreshToken: apiResponse.message)
                    print("Step: 3")
                    self.errorHandlingManager.errorMessage = nil
                    print("Step: 4")
                    self.requestAccessToken() { accessTokenSuccess in
                        if accessTokenSuccess {
                            if let accessToken = self.getAccessToken() {
                                self.fetchUserData(accessToken: accessToken)
                            }
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorHandlingManager.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Fetch tokens and and sign in
    func signUp() {
        // Create and verify new account
        APIManager.createAccount(email: current.email, firstName: current.firstName, lastName: current.lastName, password: password, passwordConfirmation: passwordConfirmation) { accountSuccess in
            switch accountSuccess {
            case .success(let apiResponse):
                print("Successfully signed in: \(apiResponse.message)")
                self.verify { verifySuccess in
                    if verifySuccess {
                        // Verification succeeded, fetch access token and user
                        self.requestAccessToken() { accessTokenSuccess in
                            if accessTokenSuccess {
                                if let accessToken = self.getAccessToken() {
                                    self.fetchUserData(accessToken: accessToken)
                                }
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.errorHandlingManager.errorMessage = nil
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorHandlingManager.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func signOut() {
        DispatchQueue.main.async {
            self.isAuthenticated = false
            self.saveRefreshToken(refreshToken: "abc")
            self.saveAccessToken(accessToken: "abc")
            self.password = ""
            self.passwordConfirmation = ""
            self.current.email = ""
            self.current.firstName = ""
            self.current.lastName = ""
            print("Successfully signed out")
        }
    }

    func verify(completion: @escaping (Bool) -> Void) {
        APIManager.verifyAccount(email: current.email, password: password) { result in
            switch result {
            case .success(let refreshTokenResponse):
                self.saveRefreshToken(refreshToken: refreshTokenResponse.refresh_token)
                DispatchQueue.main.async {
                    self.errorHandlingManager.errorMessage = nil
                }
                print("Successfully verified account.")
                completion(true)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorHandlingManager.errorMessage = error.localizedDescription
                }
                completion(false)
            }
        }
    }
        
    // Request new access token and prompt user to log in if refresh token is invalid
    /* func fetchAccessToken() {
        print("Started fetchAccessToken")
        guard let refreshToken = loadRefreshToken() else {
            self.errorHandlingManager.errorMessage = "No Refresh Token available"
            return
        }

        APIManager.fetchAccessToken(refreshToken: refreshToken) { result in
            switch result {
            case .success(let apiResponse):
                print("\tfetchAccessToken.success")
                self.saveAccessToken(accessToken: apiResponse.message)
                DispatchQueue.main.async {
                    self.errorHandlingManager.errorMessage = nil
                    self.isAuthenticated = true
                }
            case .failure(let error):
                print("\tfetchAccessToken.failure")
                DispatchQueue.main.async {
                    self.errorHandlingManager.errorMessage = error.localizedDescription
                    self.isAuthenticated = false
                }
            }
        }
    }*/
    
    func requestAccessToken(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = loadRefreshToken() else {
            self.errorHandlingManager.errorMessage = "No Refresh Token available"
            completion(false)
            return
        }

        APIManager.fetchAccessToken(refreshToken: refreshToken) { result in
            switch result {
            case .success(let apiResponse):
                self.saveAccessToken(accessToken: apiResponse.message)
                DispatchQueue.main.async {
                    self.errorHandlingManager.errorMessage = nil
                    self.isAuthenticated = true
                    completion(true)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorHandlingManager.errorMessage = error.localizedDescription
                    self.isAuthenticated = false // Prompt user to log in again if refresh token is invalid
                    completion(false)
                }
            }
        }
    }

    // load access token or request a new one if missing
    func getAccessToken() -> String? {
        if let accessToken = loadAccessToken() {
            return accessToken // Access token already exists
        } else {
            guard let refreshToken = loadRefreshToken() else {
                self.errorHandlingManager.errorMessage = "No Refresh Token available"
                return nil // If no refresh token is available, return nil
            }

            APIManager.fetchAccessToken(refreshToken: refreshToken) { result in
                switch result {
                case .success(let apiResponse):
                    self.saveAccessToken(accessToken: apiResponse.message)
                    DispatchQueue.main.async {
                        self.errorHandlingManager.errorMessage = nil
                        self.isAuthenticated = true
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.errorHandlingManager.errorMessage = error.localizedDescription
                        self.isAuthenticated = false // Prompt user to log in again if refresh token is invalid
                    }
                }
            }
            
            return nil // Return nil initially, as the new access token is being fetched
        }
    }
    
    func fetchUserData(accessToken: String) {
        APIManager.fetchAccount(accessToken: accessToken) { result in
            switch result {
            case .success(let userResponse):
                // Save user data to UserDefaults
                if let userJSON = userResponse.user.toJSON() {
                    UserDefaults.standard.set(userJSON, forKey: "cachedUserJSON")
                }
                
                DispatchQueue.main.async {
                    self.errorHandlingManager.errorMessage = nil
                }
                print("Successfully fetched user data")
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorHandlingManager.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
