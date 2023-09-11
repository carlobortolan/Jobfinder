//
//  ApplicationHandler.swift
//  mobile
//
//  Created by cb on 06.09.23.
//

import Foundation

class ApplicationHandler {
    
    static func fetchApplication(accessToken: String, jobId: Int, completion: @escaping (Result<ApplicationResponse, APIError>) -> Void) {
        print("Started fetching own applications with: \naccess_token: \(accessToken)")
        guard let urlComponents = URLComponents(string: Routes.ROOT_URL + Routes.JOBS_PATH + "/\(jobId)" +  Routes.APPLICATION_PATH ) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        print("URL: \(url)")
        
        RequestHandler.performRequest(url: url, httpMethod: HTTPMethod.GET, accessToken: accessToken, responseType: ApplicationResponse.self, completion: completion)
    }
    
    static func fetchOwnApplications(accessToken: String, completion: @escaping (Result<ApplicationsResponse, APIError>) -> Void) {
        print("Started fetching own applications with: \naccess_token: \(accessToken)")
        guard let urlComponents = URLComponents(string: Routes.ROOT_URL + Routes.USER_APPLICATIONS_PATH) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        print("URL: \(url)")
        
        RequestHandler.performRequest(url: url, httpMethod: HTTPMethod.GET, accessToken: accessToken, responseType: ApplicationsResponse.self, completion: completion)
    }
    
    static func createApplication(accessToken: String, application: Application, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
        print("Started creating application with: \naccess_token: \(accessToken)")
        guard let urlComponents = URLComponents(string: Routes.ROOT_URL + Routes.JOBS_PATH + "/\(application.jobId)" + Routes.APPLICATIONS_PATH) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        print("URL: \(url)")
        
        let requestBody = ["application": ["application_text": application.applicationText]]
        
        RequestHandler.performRequest(
            url: url,
            httpMethod: HTTPMethod.POST,
            accessToken: accessToken,
            responseType: APIResponse.self,
            requestBody: requestBody,
            completion: completion
        )
    }
    
    static func acceptApplication(accessToken: String, message: String?, application: Application, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
        print("Started accepting application with: \naccess_token: \(accessToken)\njobId: \(application.jobId)\nuserId: \(application.userId)")
        guard let urlComponents = URLComponents(string: Routes.ROOT_URL + Routes.JOBS_PATH + "/\(application.jobId)" + Routes.APPLICATIONS_PATH + "/\(application.userId)" + Routes.ACCEPT_PATH) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        print("URL: \(url)")
         
        if let message {
            RequestHandler.performRequest(
                url: url,
                httpMethod: HTTPMethod.PATCH,
                accessToken: accessToken,
                responseType: APIResponse.self,
                queryParameters: ["message": message],
                completion: completion
            )
        } else {
            RequestHandler.performRequest(
                url: url,
                httpMethod: HTTPMethod.PATCH,
                accessToken: accessToken,
                responseType: APIResponse.self,
                completion: completion
            )
        }
    }
    
    static func rejectApplication(accessToken: String, message: String?, application: Application, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
        print("Started rejecting application with: \naccess_token: \(accessToken)\njobId: \(application.jobId)\nuserId: \(application.userId)")
        guard let urlComponents = URLComponents(string: Routes.ROOT_URL + Routes.JOBS_PATH + "/\(application.jobId)" + Routes.APPLICATIONS_PATH + "/\(application.userId)" + Routes.REJECT_PATH) else {
            completion(.failure(APIError.invalidURL))
            return
        }

        guard let url = urlComponents.url else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        print("URL: \(url)")
                
        if let message {
            RequestHandler.performRequest(
                url: url,
                httpMethod: HTTPMethod.PATCH,
                accessToken: accessToken,
                responseType: APIResponse.self,
                queryParameters: ["message": message],
                completion: completion
            )
        } else {
            RequestHandler.performRequest(
                url: url,
                httpMethod: HTTPMethod.PATCH,
                accessToken: accessToken,
                responseType: APIResponse.self,
                completion: completion
            )
        }
    }
}

