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
        guard let rootUrl = ProcessInfo.processInfo.environment["ROOT_URL"],
              let jobsPath = ProcessInfo.processInfo.environment["JOBS_PATH"],
              let applicationsPath = ProcessInfo.processInfo.environment["APPLICATION_PATH"],
              let urlComponents = URLComponents(string: rootUrl + jobsPath + "/\(jobId)" +  applicationsPath ) else {
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
        
        RequestHandler.performRequest(url: url, httpMethod: HTTPMethod.GET, accessToken: accessToken, responseType: ApplicationsResponse.self, completion: completion)
    }
    
    static func createApplication(accessToken: String, application: Application, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
        print("Started creating application with: \naccess_token: \(accessToken)")
        guard let rootUrl = ProcessInfo.processInfo.environment["ROOT_URL"],
              let jobsPath = ProcessInfo.processInfo.environment["JOBS_PATH"],
              let applicationsPath = ProcessInfo.processInfo.environment["APPLICATIONS_PATH"],
              let urlComponents = URLComponents(string: rootUrl + jobsPath + "/\(application.jobId)" + applicationsPath) else {
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
        guard let rootUrl = ProcessInfo.processInfo.environment["ROOT_URL"],
              let jobsPath = ProcessInfo.processInfo.environment["JOBS_PATH"],
              let applicationsPath = ProcessInfo.processInfo.environment["APPLICATIONS_PATH"],
              let acceptPath = ProcessInfo.processInfo.environment["ACCEPT_PATH"],
              let urlComponents = URLComponents(string: rootUrl + jobsPath + "/\(application.jobId)" + applicationsPath + "/\(application.userId)" + acceptPath) else {
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
        guard let rootUrl = ProcessInfo.processInfo.environment["ROOT_URL"],
              let jobsPath = ProcessInfo.processInfo.environment["JOBS_PATH"],
              let applicationsPath = ProcessInfo.processInfo.environment["APPLICATIONS_PATH"],
              let rejectPath = ProcessInfo.processInfo.environment["REJECT_PATH"],
              let urlComponents = URLComponents(string: rootUrl + jobsPath + "/\(application.jobId)" + applicationsPath + "/\(application.userId)" + rejectPath) else {
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

