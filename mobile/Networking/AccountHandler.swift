//
//  AccountHandler.swift
//  mobile
//
//  Created by cb on 06.09.23.
//

import Foundation

class AccountHandler {
           
    static func createAccountNew (email: String, firstName: String, lastName: String, password: String, passwordConfirmation: String, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
        print("Started creating account with: \nemail: \(email)\nfirstName: \(firstName)\nlastName: \(lastName)\npassword: \(password)\npasswordConfirmation: \(passwordConfirmation)")
        guard let rootUrl = ProcessInfo.processInfo.environment["ROOT_URL"],
              let preferencesPath = ProcessInfo.processInfo.environment["USER_VERIFY_PATH"],
              let urlComponents = URLComponents(string: rootUrl + preferencesPath) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        print("URL: \(url)")

        let requestBody = ["user": ["email": email, "first_name": firstName, "last_name": lastName, "password": password, "password_confirmation": passwordConfirmation]]
        
        RequestHandler.performRequest(
            url: url,
            httpMethod: HTTPMethod.POST,
            responseType: APIResponse.self,
            requestBody: requestBody,
            completion: completion
        )
    }

    static func verifyAccount(email: String, password: String, completion: @escaping (Result<RefreshTokenResponse, APIError>) -> Void) {
        print("Started verifying account with: \nemail: \(email)\npassword: \(password)")
        guard let rootUrl = ProcessInfo.processInfo.environment["ROOT_URL"],
              let preferencesPath = ProcessInfo.processInfo.environment["USER_VERIFY_PATH"],
              let urlComponents = URLComponents(string: rootUrl + preferencesPath) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        print("URL: \(url)")
        let loginString = "\(email):\(password)"
        if let loginData = loginString.data(using: .utf8)?.base64EncodedString() {
                let authentication = Authentication(field: "Authorization", value: "Basic \(loginData)")
            RequestHandler.performRequest(
                url: url,
                httpMethod: HTTPMethod.GET,
                responseType: RefreshTokenResponse.self,
                authentication: authentication,
                completion: completion
            )
        } else {
            completion(.failure(APIError.argumentError("Email or password missing!")))
        }
    }
    
    static func fetchAccount(accessToken: String, completion: @escaping (Result<UserResponse, APIError>) -> Void) {
        print("Started fetching account with: \naccess_token: \(accessToken)")
        guard let rootUrl = ProcessInfo.processInfo.environment["ROOT_URL"],
              let userPath = ProcessInfo.processInfo.environment["USER_PATH"],
              let urlComponents = URLComponents(string: rootUrl + userPath) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        print("URL: \(url)")

        RequestHandler.performRequest(
            url: url,
            httpMethod: HTTPMethod.GET,
            accessToken: accessToken,
            responseType: UserResponse.self,
            completion: completion)
    }
    
    static func fetchPreferences(accessToken: String, completion: @escaping (Result<PreferencesResponse, APIError>) -> Void) {
        print("Started fetching preferences with: \naccess_token: \(accessToken)")
        guard let rootUrl = ProcessInfo.processInfo.environment["ROOT_URL"],
              let preferencesPath = ProcessInfo.processInfo.environment["USER_PREFERENCES_PATH"],
              let urlComponents = URLComponents(string: rootUrl + preferencesPath) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        print("URL: \(url)")

        RequestHandler.performRequest(
            url: url,
            httpMethod: HTTPMethod.GET,
            accessToken: accessToken,
            responseType: PreferencesResponse.self,
            completion: completion)
    }
    
    static func removeImage(accessToken: String, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
        print("Started removing image with: \naccess_token: \(accessToken)")
        guard let rootUrl = ProcessInfo.processInfo.environment["ROOT_URL"],
              let preferencesPath = ProcessInfo.processInfo.environment["USER_IMAGE_PATH"],
              let urlComponents = URLComponents(string: rootUrl + preferencesPath) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        print("URL: \(url)")

        RequestHandler.performRequest(
            url: url,
            httpMethod: HTTPMethod.DELETE,
            accessToken: accessToken,
            responseType: APIResponse.self,
            completion: completion)
    }
    
    static func updateAccount(accessToken: String, user: User, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
        print("Started updating account with: \naccess_token: \(accessToken)")
        guard let rootUrl = ProcessInfo.processInfo.environment["ROOT_URL"],
              let preferencesPath = ProcessInfo.processInfo.environment["USER_PATH"],
              let urlComponents = URLComponents(string: rootUrl + preferencesPath) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        print("URL: \(url)")
        
        let requestBody = RequestBody(data: user)

        RequestHandler.performRequest(
            url: url,
            httpMethod: HTTPMethod.PATCH,
            accessToken: accessToken,
            responseType: APIResponse.self,
            requestBody: requestBody,
            completion: completion
        )
    }
}
