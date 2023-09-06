//
//  APIManager.swift
//  mobile
//
//  Created by cb on 15.08.23.
//
//  Serves as an interface for all API Handlers
//
//  Editor's note: THIS IS USED TO PREVENT THE READER TO GET IN CONTACT WITH THE TERRIBLE SPAGHETTI CODE BEHIND THIS CODE
//  The reason for this approach is that it works and Swift doesn't provide a better way to do it (not that I currently know of.
//  For more detailed information on each method, check out the specific handler's documentation.
//

import Foundation

class APIManager {

    /// AccountHandler

    /// Delegates the creation of a user account to AccountHandler.
    ///
    /// - Parameters:
    ///   - email: The email address of the user.
    ///   - firstName: The first name of the user.
    ///   - lastName: The last name of the user.
    ///   - password: The user's password.
    ///   - passwordConfirmation: The confirmation of the user's password.
    ///   - completion: A closure that receives a `Result` with an `APIResponse` or an `APIError`.
    static func createAccount(email: String, firstName: String, lastName: String, password: String, passwordConfirmation: String, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
        AccountHandler.createAccount(email: email, firstName: firstName, lastName: lastName, password: password, passwordConfirmation: passwordConfirmation, completion: completion)
    }

    /// Delegates the verification of a user account to AccountHandler.
    ///
    /// - Parameters:
    ///   - email: The email address of the user.
    ///   - password: The user's password.
    ///   - completion: A closure that receives a `Result` with an `APIResponse` or an `APIError`.
    static func verifyAccount(email: String, password: String, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
        AccountHandler.verifyAccount(email: email, password: password, completion: completion)
    }

    /// Delegates the fetching of job feed to FeedHandler.
    ///
    /// - Parameters:
    ///   - longitude: The longitude for location-based filtering.
    ///   - latitude: The latitude for location-based filtering.
    ///   - page: The page number for pagination.
    ///   - accessToken: The user's access token for authentication.
    ///   - completion: A closure that receives a `Result` with an array of `Job` or an `APIError`.
    static func fetchFeed(longitude: Float, latitude: Float, page: Int, accessToken: String, completion: @escaping (Result<[Job], APIError>) -> Void) {
        FeedHandler.fetchFeed(longitude: longitude, latitude: latitude, page: page, accessToken: accessToken, completion: completion)
    }

    /// Delegates the querying of jobs to FeedHandler.
    ///
    /// - Parameters:
    ///   - query: The query string for job searching.
    ///   - jobType: The type of job to filter by.
    ///   - sortBy: The sorting criteria for the job list.
    ///   - accessToken: The user's access token for authentication.
    ///   - completion: A closure that receives a `Result` with an array of `Job` or an `APIError`.
    static func queryJobs(query: String, jobType: String, sortBy: String, accessToken: String, completion: @escaping (Result<[Job], APIError>) -> Void) {
        FeedHandler.queryJobs(query: query, jobType: jobType, sortBy: sortBy, accessToken: accessToken, completion: completion)
    }

    /// Delegates the execution of a network request to RequestHandler.
    ///
    /// - Parameters:
    ///   - url: The URL for the network request.
    ///   - accessToken: The user's access token for authentication.
    ///   - completion: A closure that receives a `Result` with an array of `Job` or an `APIError`.
    static func performRequest(url: URL, accessToken: String, completion: @escaping (Result<[Job], APIError>) -> Void) {
        RequestHandler.performRequest(url: url, accessToken: accessToken, completion: completion)
    }

    /// Delegates the handling of API errors to RequestHandler.
    ///
    /// - Parameters:
    ///   - json: The JSON response received from the API.
    ///   - errorKeys: An array of error keys to check in the JSON response.
    ///   - statusCode: The HTTP status code of the API response.
    ///   - completion: A closure that receives a `Result` with a generic type conforming to `Decodable` or an `APIError`.
    static func handleApiErrors<T: Decodable>(json: Any, errorKeys: [String], statusCode: Int, completion: @escaping (Result<T, APIError>) -> Void) {
        RequestHandler.handleApiErrors(json: json, errorKeys: errorKeys, statusCode: statusCode, completion: completion)
    }

    /// Delegates the fetching of a refresh token to TokenHandler.
    ///
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    ///   - completion: A closure that receives a `Result` with an `APIResponse` or an `APIError`.
    static func fetchRefreshToken(email: String, password: String, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
        TokenHandler.fetchRefreshToken(email: email, password: password, completion: completion)
    }

    /// Delegates the fetching of an access token using a refresh token to TokenHandler.
    ///
    /// - Parameters:
    ///   - refreshToken: The user's refresh token.
    ///   - completion: A closure that receives a `Result` with an `APIResponse` or an `APIError`.
    static func fetchAccessToken(refreshToken: String, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
        TokenHandler.fetchAccessToken(refreshToken: refreshToken, completion: completion)
    }}
