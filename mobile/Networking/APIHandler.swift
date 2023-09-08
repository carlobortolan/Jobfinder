//
//  APIRequest.swift
//  mobile
//
//  Created by cb on 06.09.23.
//

import Foundation

class RequestHandler {
    
    static func performRequest<T: Decodable>(
        url: URL,
        httpMethod: HTTPMethod,
        accessToken: String? = nil, // Optional access token (e.g. verify, createAccount)
        responseType: T.Type,
        requestBody: Any? = nil, // Optional request body TODO: FIX TYPES
        queryParameters: QueryParameters? = nil, // Optional query parameters
        authentication: Authentication? = nil, // Optional authentication information
        requestHeaders: RequestHeaders? = nil, // Optional request headers
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        // Create a URLComponents object to build the URL with query parameters
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        // Add query parameters if provided
        if let queryParameters = queryParameters {
            components?.queryItems = queryParameters.map { key, value in
                URLQueryItem(name: key, value: value)
            }
        }
        
        // Create the final URL with query parameters
        if let finalURL = components?.url {
            var request = URLRequest(url: finalURL)
            request.httpMethod = String(describing: httpMethod)
            if let accessToken {
                request.addValue(accessToken, forHTTPHeaderField: "access_token")
            }
            
            // Set optional authentication information in request headers
            if let authentication = authentication {
                request.setValue(authentication.value, forHTTPHeaderField: authentication.field)
            }
            
            // Set optional request headers
            requestHeaders?.forEach { field, value in
                request.setValue(value, forHTTPHeaderField: field)
            }
            
            // Set optional request body
            if let requestBody = requestBody {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
                    request.httpBody = jsonData
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                } catch {
                    completion(.failure(APIError.jsonEncodingError(error)))
                    return
                }
            }
            
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
                        completion(.failure(APIError.noContent(String(describing: T.self))))
                    //case 400:
                    //    completion(.failure(APIError.badRequest))
                    case 401:
                        completion(.failure(APIError.authenticationError))
                    case 403:
                        completion(.failure(APIError.forbidden))
                    case 404:
                        completion(.failure(APIError.notFound))
                    case 500:
                        completion(.failure(APIError.internalServerError))
                    case 200:
                        if let data = data {
                            do {
                                if let responseString = String(data: data, encoding: .utf8) {
                                    print("Data as String: \(responseString)")
                                } else {
                                    print("Failed to convert data to string")
                                }
                                let responseData = try JSONDecoder().decode(T.self, from: data)
                                completion(.success(responseData))
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
                                handleApiErrors(json: json, errorKeys: ["token","error", "user", "application", "email", "first_name", "last_name", "password", "password_confirmation", "validity", "email|password", "email||password", String(describing: T.self)], statusCode: statusCode, completion: completion)
                            } catch {
                                completion(.failure(APIError.jsonParsingError(error)))
                            }
                        } else {
                            completion(.failure(APIError.unknownError))
                        }
                    }
                }
            }.resume()
        } else {
            completion(.failure(APIError.unknownError))
        }
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
    /// RequestHandler.handleApiErrors(json: responseJson, errorKeys: ["token", "user"], statusCode: 401) { result in
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
