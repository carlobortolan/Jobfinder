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
    /// ```swift
    /// let email = "user@example.com"
    /// let password = "secret_password"
    ///
    /// APIManager.fetchRefreshToken(email: email, password: password) { result in
    ///     switch result {
    ///     case .success(let response):
    ///         // Handle successful refresh token retrieval (e.g., store the refresh token securely)
    ///         print("Refresh Token: \(response.message)")
    ///     case .failure(let error):
    ///         // Handle API error (e.g., display error message to the user)
    ///         print("API Error: \(error)")
    ///     }
    /// }
    /// ```
    ///
    /// - SeeAlso: `APIResponse` for the response data structure.
    /// - SeeAlso: `APIError` for the possible API error types.
    /// - SeeAlso: `Result` for the result type that contains either the decoded response data or an API error.
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
    /// ```swift
    /// let refreshToken = "your_refresh_token"
    ///
    /// APIManager.fetchAccessToken(refreshToken: refreshToken) { result in
    ///     switch result {
    ///     case .success(let response):
    ///         // Handle successful token retrieval (e.g., update user's access token)
    ///         print("New Access Token: \(response.message)")
    ///     case .failure(let error):
    ///         // Handle API error (e.g., display error message to the user)
    ///         print("API Error: \(error)")
    ///     }
    /// }
    /// ```
    ///
    /// - SeeAlso: `APIResponse` for the response data structure.
    /// - SeeAlso: `APIError` for the possible API error types.
    /// - SeeAlso: `Result` for the result type that contains either the decoded response data or an API error.
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
    /// ```swift
    /// let email = "user@example.com"
    /// let firstName = "John"
    /// let lastName = "Doe"
    /// let password = "password123"
    /// let passwordConfirmation = "password123"
    ///
    /// APIManager.createAccount(email: email, firstName: firstName, lastName: lastName, password: password, passwordConfirmation: passwordConfirmation) { result in
    ///     switch result {
    ///     case .success(let response):
    ///         // Handle successful account creation (e.g., display success message)
    ///         print("Account Created: \(response.message)")
    ///     case .failure(let error):
    ///         // Handle API error (e.g., display error message to the user)
    ///         print("API Error: \(error)")
    ///     }
    /// }
    /// ```
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
    /// ```swift
    /// let email = "user@example.com"
    /// let password = "password123"
    ///
    /// APIManager.verifyAccount(email: email, password: password) { result in
    ///     switch result {
    ///     case .success(let response):
    ///         // Handle successful account verification (e.g., display success message)
    ///         print("Verification Successful: \(response.message)")
    ///     case .failure(let error):
    ///         // Handle API error (e.g., display error message to the user)
    ///         print("API Error: \(error)")
    ///     }
    /// }
    /// ```
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
    
    /// Queries jobs based on search criteria and access token.
    ///
    /// This function initiates a network request to query jobs based on the specified search criteria, including query keywords,
    /// job type, and sorting options. It constructs the request URL with query parameters for search criteria and access token,
    /// then delegates the request to the `performRequest` function for execution. The response is processed, and the result is
    /// returned in the completion closure.
    ///
    /// - Parameters:
    ///   - query: The query string containing search keywords.
    ///   - jobType: The type of jobs to search for (e.g., "full-time," "part-time").
    ///   - sortBy: The sorting criteria for search results (e.g., "relevance," "date").
    ///   - accessToken: The access token required for authentication with the API.
    ///   - completion: A closure that receives a `Result` containing either an array of jobs or an API error.
    ///
    /// Example usage:
    ///
    /// ```swift
    /// let query = "software engineer"
    /// let jobType = "full-time"
    /// let sortBy = "relevance"
    /// let accessToken = "your_access_token"
    ///
    /// APIManager.queryJobs(query: query, jobType: jobType, sortBy: sortBy, accessToken: accessToken) { result in
    ///     switch result {
    ///     case .success(let jobs):
    ///         // Handle successful response data (e.g., display job listings)
    ///     case .failure(let error):
    ///         // Handle API error (e.g., display error message to the user)
    ///         print("API Error: \(error)")
    ///     }
    /// }
    /// ```
    ///
    /// - SeeAlso: `performRequest` for the underlying request implementation.
    /// - SeeAlso: `APIError` for the possible API error types.
    /// - SeeAlso: `Result` for the result type that contains either the decoded response data or an API error.
    static func queryJobs(query: String, jobType: String, sortBy: String, accessToken: String, completion: @escaping (Result<[Job], APIError>) -> Void) {
        print("Started querying jobs with: \nquery: \(query)\njobType: \(jobType)\nsortBy: \(sortBy)\naccess_token: \(accessToken)")
        guard let rootUrl = ProcessInfo.processInfo.environment["ROOT_URL"],
              let jobsFindPath = ProcessInfo.processInfo.environment["JOBS_FIND_PATH"],
              var urlComponents = URLComponents(string: rootUrl + jobsFindPath) else {
            completion(.failure(APIError.invalidURL))
            return
        }

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

        performRequest(url: url, accessToken: accessToken, completion: completion)
    }

    /// Fetches a feed of jobs based on geographical coordinates and access token.
    ///
    /// This function initiates a network request to retrieve a feed of jobs near the specified latitude and longitude.
    /// It constructs the request URL with query parameters for geographical location and access token, then delegates
    /// the request to the `performRequest` function for execution. The response is processed, and the result is
    /// returned in the completion closure.
    ///
    /// - Parameters:
    ///   - longitude: The longitude coordinate for the job search location.
    ///   - latitude: The latitude coordinate for the job search location.
    ///   - page: The page number for paginating results (currently not implemented).
    ///   - accessToken: The access token required for authentication with the API.
    ///   - completion: A closure that receives a `Result` containing either an array of jobs or an API error.
    ///
    /// - Note: This function does not currently implement pagination with the `page` parameter, but the TODO comment
    ///         indicates the intent to add pagination in the future. Ensure that the API supports pagination when
    ///         implementing this feature.
    ///
    /// Example usage:
    ///
    /// ```swift
    /// let longitude: Float = 123.456
    /// let latitude: Float = 45.678
    /// let page: Int = 1
    /// let accessToken = "your_access_token"
    ///
    /// APIManager.fetchFeed(longitude: longitude, latitude: latitude, page: page, accessToken: accessToken) { result in
    ///     switch result {
    ///     case .success(let jobs):
    ///         // Handle successful response data (e.g., display job listings)
    ///     case .failure(let error):
    ///         // Handle API error (e.g., display error message to the user)
    ///         print("API Error: \(error)")
    ///     }
    /// }
    /// ```
    ///
    /// - SeeAlso: `performRequest` for the underlying request implementation.
    /// - SeeAlso: `APIError` for the possible API error types.
    /// - SeeAlso: `Result` for the result type that contains either the decoded response data or an API error.
    static func fetchFeed(longitude: Float, latitude: Float, page: Int, accessToken: String, completion: @escaping (Result<[Job], APIError>) -> Void) {
        print("Started fetching feed with: \npage: \(page)\naccess_token: \(accessToken)")
        guard let rootUrl = ProcessInfo.processInfo.environment["ROOT_URL"],
              let jobsFindPath = ProcessInfo.processInfo.environment["JOBS_FEED_PATH"],
              var urlComponents = URLComponents(string: rootUrl + jobsFindPath) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "latitude", value: "\(latitude)"),
            URLQueryItem(name: "longitude", value: "\(longitude)"),
            // TODO: Add pagination for /jobs to Rails API:
            // URLQueryItem(name: "page", value: "\(page)")
        ]
        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        print("URL: \(url)")

        performRequest(url: url, accessToken: accessToken, completion: completion)
    }

    /// Performs an HTTP GET request to the specified URL with an access token and handles the response.
    ///
    /// This function constructs an HTTP GET request to the given URL, sets the access token in the request headers,
    /// and asynchronously performs the request. It then processes the HTTP response based on the status code
    /// and either returns the decoded response data as a `Result` or an `APIError` if an error occurs.
    ///
    /// - Parameters:
    ///   - url: The URL to which the GET request will be sent.
    ///   - accessToken: The access token to be included in the request headers.
    ///   - completion: A closure that receives a `Result` containing either the decoded response data or an API error.
    ///
    /// - Note: This function handles common HTTP status codes such as 204 (No Content), 401 (Unauthorized),
    ///         500 (Internal Server Error), and 200 (OK). For other status codes, it attempts to decode
    ///         the response data and checks for specific error keys in the JSON response.
    ///
    /// - Important: Ensure that the provided URL is valid and corresponds to an API endpoint that returns the expected data format.
    ///              If the API response format or error handling logic changes, this function may need to be updated.
    ///
    /// Example usage:
    ///
    /// ```swift
    /// let apiURL = URL(string: "https://example.com/api/jobs")!
    /// APIManager.performRequest(url: apiURL, accessToken: "your_access_token") { result in
    ///     switch result {
    ///     case .success(let jobs):
    ///         // Handle successful response data (e.g., update UI)
    ///     case .failure(let error):
    ///         // Handle API error (e.g., display error message to the user)
    ///         print("API Error: \(error)")
    ///     }
    /// }
    /// ```
    ///
    /// - SeeAlso: `APIError` for the possible API error types.
    /// - SeeAlso: `Result` for the result type that contains either the decoded response data or an API error.
    private static func performRequest(url: URL, accessToken: String, completion: @escaping (Result<[Job], APIError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(accessToken, forHTTPHeaderField: "access_token")

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error fetching data: \(error)")
                completion(.failure(APIError.networkError(error)))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                print("HTTP Response Code: \(statusCode)")

                switch statusCode {
                case 204:
                    completion(.failure(APIError.noContent("matching jobs")))
                case 401:
                    completion(.failure(APIError.authenticationError))
                case 500:
                    completion(.failure(APIError.internalServerError))
                case 200:
                    if let data = data {
                        if let responseString = String(data: data, encoding: .utf8) {
                            print("Response Data: \(responseString)")
                        } else {
                            print("Failed to convert data to string")
                        }
                        do {
                            let jobs = try JSONDecoder().decode([Job].self, from: data)
                            completion(.success(jobs))
                        } catch {
                            print("JSON Error: \(error)")
                            completion(.failure(APIError.jsonParsingError(error)))
                        }
                    } else {
                        completion(.failure(APIError.unknownError))
                    }
                default:
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            print("Error JSON = \(json)")
                            handleApiErrors(json: json, errorKeys: ["token", "jobs"], statusCode: statusCode, completion: completion)
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
    
    /// Handles API error responses and translates them into custom error types.
    ///
    /// This function takes JSON data from an API response and maps it to custom error messages
    /// based on specified `errorKeys`. It creates error messages by combining the "description" and "error" fields
    /// from the JSON data for each `errorKey`. If there are no error messages, it falls back to a general
    /// "unknown error" message. The resulting error message is then wrapped in an `APIError` and returned
    /// via the provided completion handler.
    ///
    /// - Parameters:
    ///   - json: The JSON data from the API response.
    ///   - errorKeys: An array of keys used to look up error data in the JSON.
    ///   - statusCode: The HTTP status code of the API response.
    ///   - completion: A closure that receives a `Result` containing either the custom error or the decoded API response data.
    ///
    /// - Note: This function is designed to handle specific error formats commonly found in API responses.
    ///         If the JSON structure or error handling logic changes, this function may need to be updated.
    ///
    /// - Important: It's important to ensure that the provided `errorKeys` match the expected keys in the API response.
    ///              In case of unexpected response formats, this function falls back to an "unknown error."
    ///
    /// - SeeAlso: `APIError` for the possible custom error types.
    /// - SeeAlso: `Result` for the result type that contains either the custom error or the decoded API response data.
    ///
    /// Example usage:
    ///
    /// swift
    /// ```APIManager.handleApiErrors(json: responseJson, errorKeys: ["token", "user"], statusCode: 401) { result in
    ///     switch result {
    ///     case .success(let data):
    ///         // Handle successful response data
    ///     case .failure(let error):
    ///         // Handle API error (e.g., authentication error)
    ///         print("API Error: \(error)")
    ///     }
    /// }
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
