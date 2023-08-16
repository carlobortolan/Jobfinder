//
//  APIManager.swift
//  mobile
//
//  Created by cb on 15.08.23.
//

import Foundation

class APIManager {
    static func fetchRefreshToken(email: String, password: String, completion: @escaping (Result<APIResponse, Error>) -> Void) {
        guard let rootUrl = ProcessInfo.processInfo.environment["ROOT_URL"],
              let rtPath = ProcessInfo.processInfo.environment["RT_PATH"],
              let url = URL(string: rootUrl + rtPath) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
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
                                let error = NSError(domain: "JSON Parsing Error", code: 0, userInfo: nil)
                                completion(.failure(error))
                            }
                        } catch { // JSON parsing error
                            completion(.failure(error))
                        }
                    }
                } else { // Handle non-200 response codes
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            print("Error JSON = \(json)")
                            handleApiErrors(json: json, errorKeys: ["error", "validity", "email|password", "email||password", "user"], statusCode: statusCode, completion: completion)
                        } catch {
                            completion(.failure(error))
                        }
                    }
                }
            }
        }.resume()
    }
    
    
    static func fetchAccessToken(refreshToken: String, completion: @escaping
                                 (Result<APIResponse, Error>) -> Void) {
        print("STARTED ACCESS TOKEN")
        guard let rootUrl = ProcessInfo.processInfo.environment["ROOT_URL"],
              let atPath = ProcessInfo.processInfo.environment["AT_PATH"],
              let url = URL(string: rootUrl + atPath) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(refreshToken, forHTTPHeaderField: "refresh_token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
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
                            completion(.failure(error))
                        }
                    }
                } else { // Handle non-200 response codes
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            print("Error JSON = \(json)")
                                handleApiErrors(json: json, errorKeys: ["error", "token", "user"], statusCode: statusCode, completion: completion)
                        } catch {
                            completion(.failure(error))
                        }
                    }
                }
            }
        }.resume()
    }
    
    static func createAccount (email: String, firstName: String, lastName: String, password: String, passwordConfirmation: String, completion: @escaping (Result<APIResponse, Error>) -> Void) {
        print("STARTED CREATE ACCOUNT")
        guard let rootUrl = ProcessInfo.processInfo.environment["ROOT_URL"],
              let userPath = ProcessInfo.processInfo.environment["USER_PATH"],
              let url = URL(string: rootUrl + userPath) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
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
                            DispatchQueue.main.async {
                                completion(.success(APIResponse(message: messageValue)))
                            }
                        }
                    } catch { // JSON parsing error
                        completion(.failure(error))
                    }
                } else { // Handle non-200 response codes
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            print("Error JSON = \(json)")
                            handleApiErrors(json: json, errorKeys: ["error", "user", "email", "first_name", "last_name", "password", "password_confirmation"], statusCode: statusCode, completion: completion)
                        } catch { // JSON parsing error
                            completion(.failure(error))
                        }
                    }

                }
            }
        }.resume()
    }
    
    static func verifyAccount(email: String, password: String, completion: @escaping (Result<APIResponse, Error>) -> Void) {
        guard let rootUrl = ProcessInfo.processInfo.environment["ROOT_URL"],
              let verifyPath = ProcessInfo.processInfo.environment["USER_VERIFY_PATH"],
              var urlComponents = URLComponents(string: rootUrl + verifyPath) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
       
        // Add email and password as query parameters
        urlComponents.queryItems = [
            URLQueryItem(name: "email", value: email),
            URLQueryItem(name: "password", value: password)
        ]
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
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
                                DispatchQueue.main.async {
                                    completion(.success(APIResponse(message: refreshTokenValue)))
                                }
                            } else {
                                let error = NSError(domain: "JSON Parsing Error", code: 0, userInfo: nil)
                                completion(.failure(error))
                            }
                        } catch { // JSON parsing error
                            completion(.failure(error))
                        }
                    }
                } else { // Handle non-200 response codes
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            print("Error JSON = \(json)")
                            handleApiErrors(json: json, errorKeys: ["error", "email", "password", "email||password", "user"], statusCode: statusCode, completion: completion)
                        } catch {
                            completion(.failure(error))
                        }
                    }
                }
            }
        }.resume()
    }
    
    static func handleApiErrors(json: Any, errorKeys: [String], statusCode: Int, completion: @escaping (Result<APIResponse, Error>) -> Void) {
       
        if let errorDict = json as? [String: Any] {
            var errorMessages: [String] = []
            for errorKey in errorKeys {
                if let errorTokenArray = errorDict[errorKey] as? [[String: Any]] {
                    let errorMessagesForKey = errorTokenArray.map { item in
                        return "\(item["description"] ?? "") (\(errorKey): \(item["error"] ?? ""))"
                    }
                    errorMessages.append(contentsOf: errorMessagesForKey)
                }
            }
            
            if !errorMessages.isEmpty {
                // Concat error messages into a single string
                let errorMessage = errorMessages.joined(separator: ", ")
                print("Error Message: \(errorMessage)")
                
                let error = NSError(domain: "API Error", code: statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                completion(.failure(error))
            } else {
                // Handle unexpected error response format
                let error = NSError(domain: "API Error", code: statusCode, userInfo: nil)
                completion(.failure(error))
            }
        } else {
            // Handle unexpected error response format
            let error = NSError(domain: "API Error", code: statusCode, userInfo: nil)
            completion(.failure(error))
        }
    }
}
