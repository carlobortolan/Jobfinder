//
//  ApplicationHandler.swift
//  mobile
//
//  Created by cb on 06.09.23.
//

import Foundation

class ApplicationHandler {
    
    // TODO: Implement own applications
    static func fetchOwnApplications(accessToken: String, completion: @escaping (Result<ApplicationResponse, APIError>) -> Void) {
        print("Started fetching own applications with: \naccess_token: \(accessToken)")
        guard let rootUrl = ProcessInfo.processInfo.environment["ROOT_URL"],
              let userApplicationsPath = ProcessInfo.processInfo.environment["USER_APPLICATIONS_PATH"],
              let urlComponents = URLComponents(string: rootUrl + userApplicationsPath) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        print("URL: \(url)")

        RequestHandler.performRequest(url: url, accessToken: accessToken, responseType: ApplicationResponse.self, completion: completion)
    }
}

