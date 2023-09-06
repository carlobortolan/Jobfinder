//
//  APIManager.swift
//  mobile
//
//  Created by cb on 15.08.23.
//
//  Editor's note: THIS IS TERRIBLE SPAGHETTI CODE, but it works and Swift doesn't provide a better way to do it (not that I currently know of)
//

import Foundation

class APIManager {
     static func fetchRefreshToken(email: String, password: String, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
         print("Started fetchRefreshToken")
         guard let rootUrl = ProcessInfo.processInfo.environment["ROOT_URL"],
              let rtPath = ProcessInfo.processInfo.environment["RT_PATH"],
              let url = URL(string: rootUrl + rtPath) else {
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
                            handleApiErrors(json: json, errorKeys: ["error", "validity", "email|password", "email||password", "user"], statusCode: statusCode, completion: completion)
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
    
    
    static func fetchAccessToken(refreshToken: String, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
        print("Started fetchAccessToken")
        guard let rootUrl = ProcessInfo.processInfo.environment["ROOT_URL"],
              let atPath = ProcessInfo.processInfo.environment["AT_PATH"],
              let url = URL(string: rootUrl + atPath) else {
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
                                handleApiErrors(json: json, errorKeys: ["error", "token", "user"], statusCode: statusCode, completion: completion)
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
                            handleApiErrors(json: json, errorKeys: ["error", "user", "email", "first_name", "last_name", "password", "password_confirmation"], statusCode: statusCode, completion: completion)
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
    
    static func verifyAccount(email: String, password: String, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
        print("Started verifyAccount")
        guard let rootUrl = ProcessInfo.processInfo.environment["ROOT_URL"],
              let verifyPath = ProcessInfo.processInfo.environment["USER_VERIFY_PATH"],
              let urlComponents = URLComponents(string: rootUrl + verifyPath) else {
            completion(.failure(.invalidURL))
            return
        }
       
        // Add email and password as query parameters
        /*urlComponents.queryItems = [
            URLQueryItem(name: "email", value: email),
            URLQueryItem(name: "password", value: password)
        ]*/
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
                            handleApiErrors(json: json, errorKeys: ["error", "email", "password", "email||password", "user"], statusCode: statusCode, completion: completion)
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
    
    static func queryJobs(query: String, jobType: String, sortBy: String, accessToken: String, completion: @escaping (Result<[Job], APIError>) -> Void) {
        print("Started querying jobs with: \nquery: \(query)\njobType: \(jobType)\nsortBy: \(sortBy)\naccess_token: \(accessToken)")
        guard let rootUrl = ProcessInfo.processInfo.environment["ROOT_URL"],
              let jobsFindPath = ProcessInfo.processInfo.environment["JOBS_FIND_PATH"],
              var urlComponents = URLComponents(string: rootUrl + jobsFindPath) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        // Add query parameters
        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "job_type", value: jobType),
            URLQueryItem(name: "sortBy", value: sortBy)
        ]
        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        print("URL: \(url)")

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(accessToken, forHTTPHeaderField: "access_token")
        
        
        print("Request: \(String(describing: request.allHTTPHeaderFields))")
        // Create and send the network request
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error fetching data: \(error)")
                completion(.failure(APIError.networkError(error)))
                return
           }

            if let httpResponse = response as? HTTPURLResponse {

                let statusCode = httpResponse.statusCode
                print("HTTP Response Code: \(statusCode)")
                
                
                if statusCode == 401 {
                    completion(.failure(APIError.authenticationError))
                    return
                }
                
                if statusCode == 204 {
                    completion(.failure(APIError.noContent("matching jobs")))
                    return
                }
                
                if statusCode == 200 { // Check if the response code is 200 (OK)
                    if let data = data { // Parse data into [Job] if successful
                        if let responseString = String(data: data, encoding: .utf8) {
                            print("Response Data: \(responseString)")
                        } else {
                            print("Failed to convert data to string")
                        }
                        do {
                            let jobResponse = try JSONDecoder().decode(JobResponse.self, from: data)
                            let jobs = jobResponse.jobs
                            completion(.success(jobs))
                        } catch {
                            print("JSON Error: \(error)")
                            completion(.failure(APIError.jsonParsingError(error)))
                        }
                    } else {
                        completion(.failure(APIError.unknownError))
                    }
                } else { // Handle non-200 response codes
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            print("Error JSON = \(json)")
                            handleApiErrors(json: json, errorKeys: ["token", "job"], statusCode: statusCode, completion: completion)
                        } catch {
                            completion(.failure(APIError.jsonParsingError(error)))
                        }
                    } else {
                        completion(.failure(APIError.unknownError))
                    }
                }
            }
        }.resume()
    }

    static func fetchFeed(query: String, jobType: String, sortBy: String, completion: @escaping (Result<[Job], Error>) -> Void) {
        guard let rootUrl = ProcessInfo.processInfo.environment["ROOT_URL"],
              let jobsFeedPath = ProcessInfo.processInfo.environment["JOBS_FEED_PATH"],
              var urlComponents = URLComponents(string: rootUrl + jobsFeedPath) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        // Add query parameters
        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "jobType", value: jobType),
            URLQueryItem(name: "sortBy", value: sortBy)
        ]
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // Create and send the network request
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handle the response and parse data into [Job] if successful
            if let data = data {
                print("Data: \(data)")
                do {
                    let jobs = try JSONDecoder().decode([Job].self, from: data)
                    completion(.success(jobs))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }

    
    static func handleApiErrors<T: Decodable>(json: Any, errorKeys: [String], statusCode: Int, completion: @escaping (Result<T, APIError>) -> Void) {
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

                let error = APIError.argumentError(errorMessage)
                completion(.failure(error))
            } else {
                // Handle unexpected error response format
                let error = APIError.unknownError
                completion(.failure(error))
            }
        } else {
            // Handle unexpected error response format
            let error = APIError.unknownError
            completion(.failure(error))
        }
    }
}
