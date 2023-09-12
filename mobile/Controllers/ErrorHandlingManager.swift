//
//  ErrorHandlingManager.swift
//  mobile
//
//  Created by cb on 16.08.23.
//

import Foundation
import Foundation

class ErrorHandlingManager: ObservableObject {
    @Published var errorMessage: String?
}

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case authenticationError // 401
    case jsonParsingError(Error)
    case jsonEncodingError(Error)
    case imageProcessingError
    case argumentError(String) // 400
    case validationError(String) // 422
    case unknownError
    case internalServerError // 500
    case forbidden // 403
    case notFound // 404
    case noContent(String)
    case fileFormatError(String)
    
    // TODO: Add other error cases as needed

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let error):
            return "Network Error: \(error.localizedDescription)"
        case .authenticationError:
            return "Authentication Error: Invalid access token"
        case .jsonParsingError(let error):
            return "JSON Parsing Error: \(error.localizedDescription) \(error)"
        case .jsonEncodingError(let error):
            return "JSON Encoding Error: \(error.localizedDescription) \(error)"
        case .imageProcessingError:
            return "Image processing error"
        case .argumentError(let message):
            return "Argument Error: \(message)"
        case .validationError(let message):
            return "Validation Error: \(message)"
        case .unknownError:
            return "Unknown Error"
        case .internalServerError:
            return "Internal Server Error: Something went wrong on our end."
        case .forbidden:
            return "Forbidden. Proceeding is inhibited by an access restriction"
        case .notFound:
            return "Not found. This page does not exist."
        case .noContent(let cause):
            return "No \(cause) found"
        case .fileFormatError(let message):
            return "File Format Error: \(message)"
        }
    }
}
