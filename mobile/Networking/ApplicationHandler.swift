//
//  ApplicationHandler.swift
//  mobile
//
//  Created by cb on 06.09.23.
//

import Foundation

class ApplicationHandler {
    
    // TODO: Implement own applications
    static func fetchOwnApplications(accessToken: String, completion: @escaping (Result<[Application], APIError>) -> Void) {
        print("Started fetching own applications with: \naccess_token: \(accessToken)")
        guard let rootUrl = ProcessInfo.processInfo.environment["ROOT_URL"],
              let ownApplicationsPath = ProcessInfo.processInfo.environment["OWN_APPLICATIONS_PATH"],
              let urlComponents = URLComponents(string: rootUrl + ownApplicationsPath) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        print("URL: \(url)")

        RequestHandler.performRequest(url: url, accessToken: accessToken, responseType: [Application].self, completion: completion)
    }

}

