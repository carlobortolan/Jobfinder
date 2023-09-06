//
//  JobHandler.swift
//  mobile
//
//  Created by cb on 06.09.23.
//

import Foundation

class JobHandler {
    
    // TODO: Implement own jobs
    static func fetchOwnJobs(accessToken: String, completion: @escaping (Result<[Job], APIError>) -> Void) {
        print("Started fetching own jobs with: \naccess_token: \(accessToken)")
        guard let rootUrl = ProcessInfo.processInfo.environment["ROOT_URL"],
              let ownJobsPath = ProcessInfo.processInfo.environment["OWN_JOBS_PATH"],
              let urlComponents = URLComponents(string: rootUrl + ownJobsPath) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        print("URL: \(url)")

        RequestHandler.performRequest(url: url, accessToken: accessToken, responseType: [Job].self, completion: completion)
    }
}
