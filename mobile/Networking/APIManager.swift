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
import UIKit

class APIManager {
    
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
    }

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
    ///   - completion: A closure that receives a `Result` with an `RefreshTokenResponse` or an `APIError`.
    static func verifyAccount(email: String, password: String, completion: @escaping (Result<RefreshTokenResponse, APIError>) -> Void) {
        AccountHandler.verifyAccount(email: email, password: password, completion: completion)
    }
    
    /// Delegates the fetching of a user's account to AccountHandler.
    ///
    /// - Parameters:
    ///   - accessToken: The user's access token for authentication.
    ///   - completion: A closure that receives a `Result` with an `UserResponse` or an `APIError`.
    static func fetchAccount(accessToken: String, completion: @escaping (Result<UserResponse, APIError>) -> Void) {
        AccountHandler.fetchAccount(accessToken: accessToken, completion: completion)
    }

    /// Delegates the removing of a user's profile image to AccountHandler.
    ///
    /// - Parameters:
    ///   - accessToken: The user's access token for authentication.
    ///   - completion: A closure that receives a `Result` with an `APIResponse` or an `APIError`.
    static func removeUserImage(accessToken: String, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
        AccountHandler.removeImage(accessToken: accessToken, completion: completion)
    }

    /// Delegates the deletion of a user's account to AccountHandler.
    ///
    /// - Parameters:
    ///   - accessToken: The user's access token for authentication.
    ///   - completion: A closure that receives a `Result` with an `APIResponse` or an `APIError`.
    static func deleteUser(accessToken: String, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
        AccountHandler.deleteUser(accessToken: accessToken, completion: completion)
    }
    
    /// Delegates the uploading of a user's profile image to AccountHandler.
    ///
    /// - Parameters:
    ///   - accessToken: The user's access token for authentication.
    ///   - image: The user's new profile image.
    ///   - completion: A closure that receives a `Result` with an `APIResponse` or an `APIError`.
    static func uploadUserImage(accessToken: String, image: UIImage, completion: @escaping (Result<ImageResponse, APIError>) -> Void) {
        AccountHandler.uploadImage(accessToken: accessToken, image: image, completion: completion)
    }
    
    /// Delegates the updating of a user's account information to AccountHandler.
    ///
    /// - Parameters:
    ///   - accessToken: The user's access token for authentication.
    ///   - user: The current user object.
    ///   - completion: A closure that receives a `Result` with an `APIResponse` or an `APIError`.
    static func updateAccount(accessToken: String, user: User, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
        AccountHandler.updateAccount(accessToken: accessToken, user: UserUpdateRequestBody(user: user), completion: completion)
    }
    
    /// Delegates the fetching of user's preferences to AccountHandler.
    ///
    /// - Parameters:
    ///   - accessToken: The user's access token for authentication.
    ///   - completion: A closure that receives a `Result` with a `PreferencesResponse` or an `APIError`.
    static func fetchPreferences(accessToken: String, completion: @escaping (Result<PreferencesResponse, APIError>) -> Void) {
        AccountHandler.fetchPreferences(accessToken: accessToken, completion: completion)
    }

    /// Delegates the fetching of a user's own jobs to JobHandler.
    ///
    /// - Parameters:
    ///   - accessToken: The user's access token for authentication.
    ///   - completion: A closure that receives a `Result` with an `JobsResponse` or an `APIError`.
    static func fetchOwnJobs(accessToken: String, completion: @escaping (Result<JobsResponse, APIError>) -> Void) {
        JobHandler.fetchOwnJobs(accessToken: accessToken, completion: completion)
    }
    
    /// Delegates the fetching of a user's upcoming jobs to JobHandler.
    ///
    /// - Parameters:
    ///   - accessToken: The user's access token for authentication.
    ///   - completion: A closure that receives a `Result` with an `JobResponse` or an `APIError`.
    static func fetchUpcomingJobs(accessToken: String, completion: @escaping (Result<JobsResponse, APIError>) -> Void) {
        JobHandler.fetchUpcomingJobs(accessToken: accessToken, completion: completion)
    }
    
    /// Delegates the fetching of nearby joss to JobHandler.
    ///
    /// - Parameters:
    ///   - accessToken: The user's access token for authentication.
    ///   - longitude: The position's longitude.
    ///   - latitude: The position's latitude.
    ///   - completion: A closure that receives a `Result` with an `JobResponse` or an `APIError`.
    static func fetchNearbyJobs(accessToken: String, longitude: Double, latitude: Double, completion: @escaping (Result<JobsResponse, APIError>) -> Void) {
        JobHandler.fetchNearbyJobs(accessToken: accessToken, longitude: longitude, latitude: latitude, completion: completion)
    }

    /// Delegates the fetching of a single application to ApplicationHandler.
    ///
    /// - Parameters:
    ///   - accessToken: The user's access token for authentication.
    ///   - jobId: The job's id.
    ///   - completion: A closure that receives a `Result` with a `ApplicationResponse` or an `APIError`.
    static func fetchApplication(accessToken: String, jobId: Int, completion: @escaping (Result<ApplicationResponse, APIError>) -> Void) {
        ApplicationHandler.fetchApplication(accessToken: accessToken, jobId: jobId, completion: completion)
    }
    
    /// Delegates the fetching of a user's own applications to ApplicationHandler.
    ///
    /// - Parameters:
    ///   - accessToken: The user's access token for authentication.
    ///   - completion: A closure that receives a `Result` with a `ApplicationsResponse` or an `APIError`.
    static func fetchOwnApplications(accessToken: String, completion: @escaping (Result<ApplicationsResponse, APIError>) -> Void) {
        ApplicationHandler.fetchOwnApplications(accessToken: accessToken, completion: completion)
    }
    
    /// Delegates the rejecting of an applicant's applications to ApplicationHandler.
    ///
    /// - Parameters:
    ///   - accessToken: The user's access token for authentication.
    ///   - completion: A closure that receives a `Result` with a `APIResponse` or an `APIError`.
    static func createApplication(accessToken: String, application: Application, cv: Data?, format: String?, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
        if let data = cv, let format = format {
            ApplicationHandler.createAttachmentApplication(accessToken: accessToken, application: application, attachment: data, format: format, completion: completion)
        } else {
            ApplicationHandler.createNormalApplication(accessToken: accessToken, application: application, completion: completion)
        }
    }
    
    /// Delegates the rejecting of an applicant's applications to ApplicationHandler.
    ///
    /// - Parameters:
    ///   - accessToken: The user's access token for authentication.
    ///   - completion: A closure that receives a `Result` with a `APIResponse` or an `APIError`.
    static func rejectApplication(accessToken: String, message: String?, application: Application, completion: @escaping (Result<APIResponse, APIError>) -> Void) {
        ApplicationHandler.rejectApplication(accessToken: accessToken, message: message, application: application, completion: completion)
    }

    
    /// Delegates the fetching of job feed to FeedHandler.
    ///
    /// - Parameters:
    ///   - longitude: The longitude for location-based filtering.
    ///   - latitude: The latitude for location-based filtering.
    ///   - page: The page number for pagination.
    ///   - accessToken: The user's access token for authentication.
    ///   - completion: A closure that receives a `Result` with a `FeedResponse` or an `APIError`.
    static func fetchFeed(longitude: Float, latitude: Float, page: Int, accessToken: String, completion: @escaping (Result<FeedResponse, APIError>) -> Void) {
        FeedHandler.fetchFeed(longitude: longitude, latitude: latitude, page: page, accessToken: accessToken, completion: completion)
    }

    /// Delegates the querying of jobs to FeedHandler.
    ///
    /// - Parameters:
    ///   - query: The query string for job searching.
    ///   - jobType: The type of job to filter by.
    ///   - sortBy: The sorting criteria for the job list.
    ///   - accessToken: The user's access token for authentication.
    ///   - completion: A closure that receives a `Result` with a `JobsResponse` or an `APIError`.
    static func queryJobs(query: String, jobType: String, sortBy: String, accessToken: String, completion: @escaping (Result<JobsResponse, APIError>) -> Void) {
        FeedHandler.queryJobs(query: query, jobType: jobType, sortBy: sortBy, accessToken: accessToken, completion: completion)
    }
}
