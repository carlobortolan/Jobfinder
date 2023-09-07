//
//  AccountHandler.swift
//  mobile
//
//  Created by cb on 06.09.23.
//

import Foundation

class AccountHandler {
    
    /// Creates a new user account with the provided user information.
    ///
    /// This function initiates a network request to create a new user account by sending user details such as email, first name,
    /// last name, password, and password confirmation to the server.
    /// It constructs the request URL with the user creation endpoint and sends the data in JSON format.
    /// The response is processed, and the result is returned in the completion closure.
    ///
    /// - Parameters:
    ///   - email: The email address for the new user account.
    ///   - firstName: The first name of the user.
    ///   - lastName: The last name of the user.
    ///   - password: The user's chosen password.
    ///   - passwordConfirmation: Confirmation of the user's chosen password.
    ///   - completion: A closure that receives a `Result` containing either an `APIResponse` or an API error.
    ///
    /// Example usage:
    ///
    /// let email = "user@example.com"
    /// let firstName = "John"
    /// let lastName = "Doe"
    /// let password = "password123"
    /// let passwordConfirmation = "password123"
    ///
    /// AccountHandler.createAccount(email: email, firstName: firstName, lastName: lastName, password: password, passwordConfirmation: passwordConfirmation) { result in
    ///     switch result {
    ///     case .success(let response):
    ///         // Handle successful account creation (e.g., display success message)
    ///         print("Account Created: \(response.message)")
    ///     case .failure(let error):
    ///         // Handle API error (e.g., display error message to the user)
    ///         print("API Error: \(error)")
    ///     }
    /// }
    ///
    /// - SeeAlso: `APIResponse` for the response data structure.
    /// - SeeAlso: `APIError` for the possible API error types.
    /// - SeeAlso: `Result` for the result type that contains either the decoded response data or an API error.
    static func createAccount (email: String, firstName: String, lastName: String, password: String, passwordConfirmation: String, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
        print("Started createAccount")
        guard let rootUrl = ProcessInfo.processInfo.environment["ROOT_URL"],
              let userPath = ProcessInfo.processInfo.environment["USER_PATH"],
              let url = URL(string: rootUrl + userPath) else {
            completion(.failure(.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = ["user": ["email": email, "first_name": firstName, "last_name": lastName, "password": password, "password_confirmation": passwordConfirmation]]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
            request.httpBody = jsonData
        } catch {
            print("Error serializing JSON: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                completion(.failure(.networkError(error)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                print("HTTP Response Code: \(statusCode)")
                
                if statusCode == 200 { // Check if the response code is 200 (OK)
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: [])
                        print("json = \(json)")
                        if let jsonDict = json as? [String: Any],
                           let messageValue = jsonDict["message"] as? String {
                            completion(.success(APIResponse(message: messageValue)))
                        }
                    } catch { // JSON parsing error
                        completion(.failure(.jsonParsingError(error)))
                    }
                } else { // Handle non-200 response codes
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            print("Error JSON = \(json)")
                            RequestHandler.handleApiErrors(json: json, errorKeys: ["error", "user", "email", "first_name", "last_name", "password", "password_confirmation"], statusCode: statusCode, completion: completion)
                        } catch { // JSON parsing error
                            completion(.failure(.jsonParsingError(error)))
                        }
                    } else {
                        completion(.failure(APIError.unknownError))
                    }
                }
            }
        }.resume()
    }
    
    /// Verifies a user account with email and password.
    ///
    /// This function initiates a network request to verify a user's account by providing email and password for authentication.
    /// It constructs the request URL with the user verification endpoint and adds the email and password as Basic Authentication headers.
    /// The response is processed, and the result is returned in the completion closure.
    ///
    /// - Parameters:
    ///   - email: The email address associated with the user account.
    ///   - password: The user's password for authentication.
    ///   - completion: A closure that receives a `Result` containing either an `APIResponse` or an API error.
    ///
    /// Example usage:
    ///
    /// let email = "user@example.com"
    /// let password = "password123"
    ///
    /// AccountHandler.verifyAccount(email: email, password: password) { result in
    ///     switch result {
    ///     case .success(let response):
    ///         // Handle successful account verification (e.g., display success message)
    ///         print("Verification Successful: \(response.message)")
    ///     case .failure(let error):
    ///         // Handle API error (e.g., display error message to the user)
    ///         print("API Error: \(error)")
    ///     }
    /// }
    ///
    /// - SeeAlso: `APIResponse` for the response data structure.
    /// - SeeAlso: `APIError` for the possible API error types.
    /// - SeeAlso: `Result` for the result type that contains either the decoded response data or an API error.
    static func verifyAccount(email: String, password: String, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
        print("Started verifyAccount")
        guard let rootUrl = ProcessInfo.processInfo.environment["ROOT_URL"],
              let verifyPath = ProcessInfo.processInfo.environment["USER_VERIFY_PATH"],
              let urlComponents = URLComponents(string: rootUrl + verifyPath) else {
            completion(.failure(.invalidURL))
            return
        }
       
        guard let url = urlComponents.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let loginString = "\(email):\(password)"
        if let loginData = loginString.data(using: .utf8)?.base64EncodedString() {
            request.setValue("Basic \(loginData)", forHTTPHeaderField: "Authorization")
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
             if let error = error {
                 print("Error fetching data: \(error)")
                 completion(.failure(.networkError(error)))
                 return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                print("HTTP Response Code: \(statusCode)")
                
                if statusCode == 200 { // Check if the response code is 200 (OK)
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            print("json = \(json)")
                            
                            if let jsonDict = json as? [String: Any],
                               let refreshTokenValue = jsonDict["refresh_token"] as? String {
                                
                                // Successfully extracted refresh token value
                                completion(.success(APIResponse(message: refreshTokenValue)))
                            } else {
                                completion(.failure(.jsonParsingError(NSError(domain: "JSON Parsing Error", code: 0, userInfo: nil))))
                            }
                        } catch { // JSON parsing error
                            completion(.failure(.jsonParsingError(error)))                        }
                    }
                } else { // Handle non-200 response codes
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            print("Error JSON = \(json)")
                            RequestHandler.handleApiErrors(json: json, errorKeys: ["error", "email", "password", "email||password", "user"], statusCode: statusCode, completion: completion)
                        } catch {
                            completion(.failure(.jsonParsingError(error)))
                        }
                    } else {
                        completion(.failure(APIError.unknownError))
                    }
                }
            }
        }.resume()
    }
    
    // TODO: Implement fetchAccount
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

        RequestHandler.performRequest(url: url, httpMethod: "GET", accessToken: accessToken, responseType: UserResponse.self, completion: completion)
    }
    
    // TODO: Implement fetchPreferences
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

        RequestHandler.performRequest(url: url, httpMethod: "GET", accessToken: accessToken, responseType: PreferencesResponse.self, completion: completion)
    }
    
    // TODO: Implement removeImage
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

        RequestHandler.performRequest(url: url, httpMethod: "DELETE", accessToken: accessToken, responseType: APIResponse.self, completion: completion)
    }
}
