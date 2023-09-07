//
//  JobHandler.swift
//  mobile
//
//  Created by cb on 06.09.23.
//

import Foundation

class JobHandler {
    
    // TODO: Implement own jobs
    static func fetchOwnJobs(accessToken: String, completion: @escaping (Result<JobResponse, APIError>) -> Void) {
        print("Started fetching own jobs with: \naccess_token: \(accessToken)")
        guard let rootUrl = ProcessInfo.processInfo.environment["ROOT_URL"],
              let userJobsPath = ProcessInfo.processInfo.environment["USER_JOBS_PATH"],
              let urlComponents = URLComponents(string: rootUrl + userJobsPath) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        print("URL: \(url)")

        RequestHandler.performRequest(url: url, accessToken: accessToken, responseType:JobResponse.self, completion: completion)
    }
}
