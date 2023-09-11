//
//  TokenHandler.swift
//  mobile
//
//  Created by cb on 06.09.23.
//

import Foundation
 
class TokenHandler {
    
    // TODO: SWITCH TO APINET
    /// Fetches a refresh token using an email and password.
    ///
    /// This function initiates a network request to obtain a refresh token using the provided email and password.
    /// It constructs the request URL with the refresh token endpoint, sends the email and password in the request body,
    /// and processes the response to extract the refresh token.
    ///
    /// - Parameters:
    ///   - email: The user's email for authentication.
    ///   - password: The user's password for authentication.
    ///   - completion: A closure that receives a `Result` containing either an `APIResponse` with the refresh token or an API error.
    ///
    /// Example usage:
    ///
    /// let email = "user@example.com"
    /// let password = "secret_password"
    ///
    /// TokenHandler.fetchRefreshToken(email: email, password: password) { result in
    ///     switch result {
    ///     case .success(let response):
    ///         // Handle successful refresh token retrieval (e.g., store the refresh token securely)
    ///         print("Refresh Token: \(response.message)")
    ///     case .failure(let error):
    ///         // Handle API error (e.g., display error message to the user)
    ///         print("API Error: \(error)")
    ///     }
    /// }
    ///
    /// - SeeAlso: `APIResponse` for the response data structure.
    /// - SeeAlso: `APIError` for the possible API error types.
    /// - SeeAlso: `Result` for the result type that contains either the decoded response data or an API error.
    static func fetchRefreshToken(email: String, password: String, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
         print("Started fetchRefreshToken")
         guard let url = URL(string: Routes.ROOT_URL + Routes.RT_PATH) else {
             completion(.failure(.invalidURL))
             return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = ["refresh_token": ["email": email, "password": password]]
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
                            completion(.failure(.jsonParsingError(error)))
                        }
                    }
                } else { // Handle non-200 response codes
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            print("Error JSON = \(json)")
                            RequestHandler.handleApiErrors(json: json, errorKeys: ["error", "validity", "email|password", "email||password", "user"], statusCode: statusCode, completion: completion)
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
    
    // TODO: SWITCH TO APINET
    /// Fetches a new access token using a refresh token.
    ///
    /// This function initiates a network request to obtain a new access token using a provided refresh token.
    /// It constructs the request URL with the access token endpoint and sends the refresh token in the request header.
    /// The response is processed, and the result is returned in the completion closure.
    ///
    /// - Parameters:
    ///   - refreshToken: The refresh token used to obtain a new access token.
    ///   - completion: A closure that receives a `Result` containing either an `APIResponse` with the new access token or an API error.
    ///
    /// Example usage:
    ///
    /// let refreshToken = "your_refresh_token"
    ///
    /// TokenHandler.fetchAccessToken(refreshToken: refreshToken) { result in
    ///     switch result {
    ///     case .success(let response):
    ///         // Handle successful token retrieval (e.g., update user's access token)
    ///         print("New Access Token: \(response.message)")
    ///     case .failure(let error):
    ///         // Handle API error (e.g., display error message to the user)
    ///         print("API Error: \(error)")
    ///     }
    /// }
    ///
    /// - SeeAlso: `APIResponse` for the response data structure.
    /// - SeeAlso: `APIError` for the possible API error types.
    /// - SeeAlso: `Result` for the result type that contains either the decoded response data or an API error.
    static func fetchAccessToken(refreshToken: String, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
        print("Started fetchAccessToken with: \nrefreshToken: \(refreshToken)")
        guard let url = URL(string: Routes.ROOT_URL + Routes.AT_PATH) else {
            completion(.failure(.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(refreshToken, forHTTPHeaderField: "refresh_token")
        
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
                               let accessTokenValue = jsonDict["access_token"] as? String {
                                // Successfully extracted access token value
                                completion(.success(APIResponse(message: accessTokenValue)))
                            }
                        } catch { // JSON parsing error
                            completion(.failure(.jsonParsingError(error)))
                        }
                    }
                } else { // Handle non-200 response codes
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            print("Error JSON = \(json)")
                            RequestHandler.handleApiErrors(json: json, errorKeys: ["error", "token", "user"], statusCode: statusCode, completion: completion)
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
}
