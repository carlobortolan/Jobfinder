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
    // @Published var isAuthenticated = false
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
                print("Check1 isAuthenticated \(self.isAuthenticated)")
                DispatchQueue.main.async {
                    self.saveRefreshToken(refreshToken: apiResponse.message)
                    self.errorHandlingManager.errorMessage = nil
                    self.fetchAccessToken()
                    print("Check2 isAuthenticated \(self.isAuthenticated)")
                }
                print("Successfully fetched new Access Token: \(apiResponse.message)")

                return
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorHandlingManager.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // Create account, fetch tokens and and sign in
    func signUp() {
        APIManager.createAccount(email: email, firstName: firstName, lastName: lastName, password: password, passwordConfirmation: passwordConfirmation) { result in
            switch result {
            case .success(let apiResponse):
                DispatchQueue.main.async {
                    self.errorHandlingManager.errorMessage = nil // Clear any previous error
                }
                print("Successfully created account: \(apiResponse.message)")
                self.verify()
                self.fetchAccessToken()
                print("Successfully signed in")
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
            print("Successfully signed out")
        }
    }

    func verify() {
        APIManager.verifyAccount(email: email, password: password) { result in
            switch result {
            case .success(let apiResponse):
                self.saveRefreshToken(refreshToken: apiResponse.message)
                DispatchQueue.main.async {
                    self.errorHandlingManager.errorMessage = nil // Clear any previous error
                }
                print("Successfully verified account. Refresh token is: \(apiResponse.message)")
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorHandlingManager.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // TODO: 0. Ask user whether he wants to save credentials (username & password) to secure chain or not
    // TODO: 1. Check for refresh token validity and depending on status prompt user to log in again or automatically fetch refresh token
    // TODO: 2. Check for auth token validity and depending on status, request new auth token
    func fetchAccessToken() {
        guard let refreshToken = loadRefreshToken() else {
            self.errorHandlingManager.errorMessage = "No Refresh Token available"
            return
        }

        APIManager.fetchAccessToken(refreshToken: refreshToken) { result in
            switch result {
            case .success(let apiResponse):
                self.saveAccessToken(accessToken: apiResponse.message)
                DispatchQueue.main.async {
                    self.errorHandlingManager.errorMessage = nil // Clear any previous error
                    self.isAuthenticated = true
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorHandlingManager.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
