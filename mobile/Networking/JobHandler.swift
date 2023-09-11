//
//  JobHandler.swift
//  mobile
//
//  Created by cb on 06.09.23.
//

import Foundation

class JobHandler {
    
    static func fetchOwnJobs(accessToken: String, completion: @escaping (Result<JobsResponse, APIError>) -> Void) {
        print("Started fetching own jobs with: \naccess_token: \(accessToken)")
        guard let urlComponents = URLComponents(string: Routes.ROOT_URL + Routes.USER_JOBS_PATH) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        print("URL: \(url)")

        RequestHandler.performRequest(url: url, httpMethod: HTTPMethod.GET, accessToken: accessToken, responseType:JobsResponse.self, completion: completion)
    }

    static func fetchUpcomingJobs(accessToken: String, completion: @escaping (Result<JobsResponse, APIError>) -> Void) {
        print("Started fetching upcoming jobs with: \naccess_token: \(accessToken)")
        guard let urlComponents = URLComponents(string: Routes.ROOT_URL + Routes.USER_UPCOMING_PATH) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        print("URL: \(url)")

        RequestHandler.performRequest(url: url, httpMethod: HTTPMethod.GET, accessToken: accessToken, responseType:JobsResponse.self, completion: completion)
    }
    
    static func fetchNearbyJobs(accessToken: String, longitude: Double, latitude: Double, completion: @escaping (Result<JobsResponse, APIError>) -> Void) {
        print("Started fetching nearby jobs with: \naccess_token: \(accessToken)\nlongitude: \(longitude)\nlatitude: \(latitude)")
        guard let urlComponents = URLComponents(string: Routes.ROOT_URL + Routes.JOBS_MAPS_PATH) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
    
        print("URL: \(url)")

        RequestHandler.performRequest(url: url, httpMethod: HTTPMethod.GET, accessToken: accessToken, responseType:JobsResponse.self, queryParameters: ["longitude": String(longitude), "latitude": String(latitude)], completion: completion)
    }
}
