//
//  APIRequest.swift
//  mobile
//
//  Created by cb on 06.09.23.
//

import Foundation

class RequestHandler {
    
    /// Performs an HTTP GET request to the specified endpoint with an access token and handles the response.
    ///
    /// This function constructs an HTTP GET request to the given URL, sets the access token in the request headers,
    /// and asynchronously performs the request. It then processes the HTTP response based on the status code
    /// and either returns the decoded response data as a `Result` or an `APIError` if an error occurs.
    ///
    /// - Parameters:
    ///   - url: The URL to which the GET request will be sent.
    ///   - httpMethod: The http method of the request.
    ///   - accessToken: The access token to be included in the request headers.
    ///   - responseType: The type of response data to be decoded from the JSON response.
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
    /// let apiURL = URL(string: "https://example.com/api/endpoint")!
    /// RequestHandler.performRequest(url: apiURL, httpMethod: "GET" accessToken: "your_access_token", responseType: YourDecodableType.self) { result in
    ///     switch result {
    ///     case .success(let responseData):
    ///         // Handle successful response data (e.g., update UI)
    ///     case .failure(let error):
    ///         // Handle API error (e.g., display error message to the user)
    ///         print("API Error: \(error)")
    ///     }
    /// }
    ///
    /// - SeeAlso: `APIError` for the possible API error types.
    /// - SeeAlso: `Result` for the result type that contains either the decoded response data or an API error.
    static func performRequest<T: Decodable>(url: URL, httpMethod: String, accessToken: String, responseType: T.Type, completion: @escaping (Result<T, APIError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
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
                            handleApiErrors(json: json, errorKeys: ["token", String(describing: T.self)], statusCode: statusCode, completion: completion)
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
