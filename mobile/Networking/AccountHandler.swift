//
//  AccountHandler.swift
//  mobile
//
//  Created by cb on 06.09.23.
//

import Foundation
import UIKit

class AccountHandler {
           
    static func createAccount (email: String, firstName: String, lastName: String, password: String, passwordConfirmation: String, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
        print("Started creating account with: \nemail: \(email)\nfirstName: \(firstName)\nlastName: \(lastName)\npassword: \(password)\npasswordConfirmation: \(passwordConfirmation)")
        guard let urlComponents = URLComponents(string: Routes.ROOT_URL + Routes.USER_PATH) else {
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
        guard let urlComponents = URLComponents(string: Routes.ROOT_URL + Routes.USER_VERIFY_PATH) else {
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
        guard let urlComponents = URLComponents(string: Routes.ROOT_URL + Routes.USER_PATH) else {
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
        guard let urlComponents = URLComponents(string: Routes.ROOT_URL + Routes.USER_PREFERENCES_PATH) else {
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
        guard let urlComponents = URLComponents(string: Routes.ROOT_URL + Routes.USER_IMAGE_PATH) else {
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

    // TODO: Improve attachment
    static func uploadImage(accessToken: String, image: UIImage, completion: @escaping (Result<ImageResponse, APIError>) -> Void) {
        print("Started uploading image with: \naccess_token: \(accessToken)")
        
        // Create a unique boundary string
        let boundary = "Boundary-\(UUID().uuidString)"
        
        // Create the URLRequest
        guard let url = URL(string: Routes.ROOT_URL + Routes.USER_IMAGE_PATH) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue(accessToken, forHTTPHeaderField: "access_token")
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image_url\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        if let imageData = image.jpegData(compressionQuality: 0.1) {
            body.append(imageData)
        } else {
            completion(.failure(APIError.imageProcessingError))
        }
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error fetching data: \(error)")
                completion(.failure(APIError.networkError(error)))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                print("HTTP Response Code: \(statusCode)")
                print("HTTP Response: \(response.debugDescription)")
                
                RequestHandler.handleApiErrorsNew(data: data, statusCode: statusCode, completion: completion)
                switch statusCode {
                case 204:
                    completion(.failure(APIError.noContent(String(describing: ImageResponse.self))))
                case 200:
                    if let data = data {
                        do {
                            if let responseString = String(data: data, encoding: .utf8) {
                                print("Data as String: \(responseString)")
                            } else {
                                print("Failed to convert data to string")
                            }
                            let responseData = try JSONDecoder().decode(ImageResponse.self, from: data)
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
    }
    
    static func deleteUser(accessToken: String, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
        print("Started deleting account with: \naccess_token: \(accessToken)")
        guard let urlComponents = URLComponents(string: Routes.ROOT_URL + Routes.USER_PATH) else {
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

    
    static func updateAccount(accessToken: String, user: UserUpdateRequestBody, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
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
        
        do {
            let jsonData = try JSONEncoder().encode(RequestBody(customData: user))
            if let jsonDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                RequestHandler.performRequest(
                    url: url,
                    httpMethod: HTTPMethod.PATCH,
                    accessToken: accessToken,
                    responseType: APIResponse.self,
                    requestBody: jsonDictionary,
                    completion: completion
                )
            }
        } catch {
            print("Error encoding JSON: \(error)")
            completion(.failure(APIError.jsonEncodingError(error)))
        }
    }
}
