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
                        } catch {
                            // JSON parsing error
                            completion(.failure(error))
                        }
                    }
                } else {
                    // Handle non-200 response codes
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            print("Error JSON = \(json)")
                            if let errorDict = json as? [String: Any],
                               let errorTokenArray = errorDict["email|password"] as? [[String: Any]] {
                                
                                // Each item in the "token" array contains "description" and "error" keys (see API documentation for more details)
                                let errorMessages = errorTokenArray.map { item in
                                    return "\(item["description"] ?? "") (Error: \(item["error"] ?? ""))"
                                }
                                
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
              let rtPath = ProcessInfo.processInfo.environment["AT_PATH"],
              let url = URL(string: rootUrl + rtPath) else {
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
                               let accessTokenDict = jsonDict["access_token"] as? [String: Any],
                               let accessTokenValue = accessTokenDict["access_token"] as? String {
                                DispatchQueue.main.async {
                                    completion(.success(APIResponse(message: accessTokenValue)))
                                }
                            }
                        } catch {
                            completion(.failure(error))
                        }
                    }
                } else {
                    // Handle non-200 response codes
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            print("Error JSON = \(json)")
                            if let errorDict = json as? [String: Any],
                               let errorTokenArray = errorDict["token"] as? [[String: Any]] {
                                
                                // Assuming each item in the "token" array contains "description" and "error" keys
                                let errorMessages = errorTokenArray.map { item in
                                    return "\(item["description"] ?? "") (Error: \(item["error"] ?? ""))"
                                }
                                
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
                        } catch {
                            completion(.failure(error))
                        }
                    }
                }
            }
        }.resume()
    }
}

