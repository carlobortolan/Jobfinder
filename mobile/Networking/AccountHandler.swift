//
//  AccountHandler.swift
//  mobile
//
//  Created by cb on 06.09.23.
//

import Foundation
import Alamofire
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

    // TODO: Improve
    static func uploadImage(accessToken: String, image: UIImage, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
        print("Started uploading image with: \naccess_token: \(accessToken)")

        // Prepare the image as Data
        guard let imageData = image.resized(toWidth: 800)?.jpegData(compressionQuality: 0.9) else {
            completion(.failure(APIError.imageProcessingError))
            return
        }
        
        // Create a unique boundary string
        let boundary = "Boundary-\(UUID().uuidString)"

        // Create the URLRequest
        guard let url = URL(string: Routes.ROOT_URL + Routes.USER_IMAGE_PATH) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // Set the request headers, including the Content-Type for multipart form data
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        // Create the request body
        var body = Data()

        // Append the boundary and form data for the image
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)

        // Append the closing boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        // Set the request body
        request.httpBody = body

        // Create a URLSession task for the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(APIError.networkError(error)))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                if (200...299).contains(httpResponse.statusCode) {
                    // Handle success, parse response data if needed
                    if let data = data {
                        print("Image uploaded successfully: \(data)")
                        // Parse and handle the response data here if needed
                        // You can decode it into your APIResponse model
                        // Example: let responseModel = try? JSONDecoder().decode(APIResponse.self, from: data)
                    } else {
                        print("Image uploaded successfully.")
                    }
                    completion(.success(APIResponse(message: "Image uploaded successfully"))) // You can replace APIResponse() with the actual response model
                } else {
                    // Handle server error
                    print("Server error: \(httpResponse.statusCode)")
                    completion(.failure(APIError.internalServerError))
                }
            }
        }

        // Start the URLSession task
        task.resume()
    }
    
    // TODO: Implement profile image upload
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
