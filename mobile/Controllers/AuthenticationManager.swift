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
    @Published var email = ""
    @Published var password = ""
    @Published var passwordConfirmation = ""
    @Published var firstName = ""
    @Published var lastName = ""
    
    init(errorHandlingManager: ErrorHandlingManager) {
        self.errorHandlingManager = errorHandlingManager
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
        APIManager.fetchRefreshToken(email: email, password: password) { result in
            switch result {
            case .success(let apiResponse):
                print("Successfully signed in: \(apiResponse.message)")
                DispatchQueue.main.async {
                    self.saveRefreshToken(refreshToken: apiResponse.message)
                    self.errorHandlingManager.errorMessage = nil
                    self.fetchAccessToken()
                }
                print("Successfully fetched new Access Token: \(apiResponse.message)")
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
        APIManager.createAccount(email: email, firstName: firstName, lastName: lastName, password: password, passwordConfirmation: passwordConfirmation) { result in
            switch result {
            case .success(let apiResponse):
                print("Successfully signed in: \(apiResponse.message)")
                self.verify { success in
                    if success {
                        // Verification succeeded, fetch access token
                        self.fetchAccessToken()
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
            self.email = ""
            self.firstName = ""
            self.lastName = ""
            print("Successfully signed out")
        }
    }

    func verify(completion: @escaping (Bool) -> Void) {
        APIManager.verifyAccount(email: email, password: password) { result in
            switch result {
            case .success(let apiResponse):
                self.saveRefreshToken(refreshToken: apiResponse.message)
                DispatchQueue.main.async {
                    self.errorHandlingManager.errorMessage = nil // Clear any previous error
                }
                print("Successfully verified account.")
                completion(true) // Indicate success
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorHandlingManager.errorMessage = error.localizedDescription
                }
                completion(false) // Indicate failure
            }
        }
    }
    
    // TODO: 0. Ask user whether he wants to save credentials (username & password) to secure chain or not
    // TODO: 1. Check for refresh token validity and depending on status prompt user to log in again or automatically fetch refresh token
    // TODO: 2. Check for auth token validity and depending on status, request new auth token
    
    // Request new access token and promt user to log in if refresh token is invalid
    func fetchAccessToken() {
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
}
