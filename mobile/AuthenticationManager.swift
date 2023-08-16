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
            KeychainManager.saveToken(refreshToken, forKey: "refreshToken")
        }
    }
    
    private func saveAccessToken(accessToken: String?) {
        if let accessToken = accessToken {
            KeychainManager.saveToken(accessToken, forKey: "accessToken")
        }
    }

    private func loadRefreshToken() -> String? {
        return KeychainManager.loadToken(forKey: "refreshToken")
    }

    private func loadAccessToken() -> String? {
        return KeychainManager.loadToken(forKey: "accessToken")
    }
    
    func signIn() {
        // Fetch refresh token
        APIManager.fetchRefreshToken(email: email, password: password) { result in
            switch result {
            case .success(let apiResponse):
                self.saveRefreshToken(refreshToken: apiResponse.message) // Save refresh token and fetch access token
                DispatchQueue.main.async {
                    self.errorHandlingManager.errorMessage = nil // Clear any previous error
                }
                self.fetchAccessToken()
                return
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorHandlingManager.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func signUp() {
        // Create account, fetch tokens and and sign in
        APIManager.createAccount(email: email, firstName: firstName, lastName: lastName, password: password, passwordConfirmation: passwordConfirmation) { result in
            switch result {
            case .success(let apiResponse):
                DispatchQueue.main.async {
                    self.errorHandlingManager.errorMessage = nil // Clear any previous error
                }
                print("Successfully created account: \(apiResponse.message)")
                self.fetchAccessToken()
                self.verify()
                self.isAuthenticated = true
                print("Successfully signed in")
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorHandlingManager.errorMessage = error.localizedDescription
                }
            }
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
                }
                return
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorHandlingManager.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
