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
            print("finalURL: \(finalURL)")
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
                    print("Requestbody: \(requestBody)")
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
                    
                    handleApiErrorsNew(data: data, statusCode: statusCode, completion: completion)
                    
                    switch statusCode {
                    case 204:
                        completion(.failure(APIError.noContent(String(describing: T.self))))
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
    
    static func handleApiErrorsNew<T: Decodable>(data: Data?, statusCode: Int, completion: @escaping (Result<T, APIError>) -> Void) {
            
        switch statusCode {
            case 400:
                break
            case 401:
                completion(.failure(APIError.authenticationError))
            case 403:
                completion(.failure(APIError.forbidden))
            case 404:
                completion(.failure(APIError.notFound))
            case 422:
                break
            case 500:
                completion(.failure(APIError.internalServerError))
            default: completion(.failure(APIError.unknownError))
        }
        
        if let data = data {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let errorJSON = json as? [String: Any], let errors = errorJSON["errors"] as? [String] {
                    let errorMessage = errors.joined(separator: ". ")
                    completion(.failure(statusCode == 422 ? APIError.validationError(errorMessage) : APIError.argumentError(errorMessage)))
                } else if let errorDict = json as? [String: Any] {
                    var errorMessages = [String]()
                    for errorKey in errorDict.keys {
                        if let errorTokenArray = errorDict[errorKey] as? [[String: Any]] {
                            let errorMessagesForKey = errorTokenArray.map { item in
                                if let description = item["description"] {
                                    return "\n\(errorKey) (\(description))"
                                } else {
                                    return ""
                                }
                            }
                            errorMessages.append(contentsOf: errorMessagesForKey)
                        }
                    }
                    if !errorMessages.isEmpty {
                        let errorMessage = errorMessages.filter { !$0.isEmpty }.joined(separator: ". ")
                        completion(.failure(statusCode == 422 ? APIError.validationError(errorMessage) : APIError.argumentError(errorMessage)))
                    } else {
                        completion(.failure(APIError.unknownError))
                    }
                } else {
                    completion(.failure(APIError.unknownError))
                }
            } catch {
                completion(.failure(APIError.jsonParsingError(error)))
            }
        } else {
            completion(.failure(APIError.unknownError))
        }
    }
    
    // TODO: @deprecated: Remove once TokenHandler has been updated
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
                
                let error = APIError.validationError(errorMessage)
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
