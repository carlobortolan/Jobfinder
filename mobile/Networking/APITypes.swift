//
//  APIResponse.swift
//  mobile
//
//  Created by cb on 15.08.23.
//

import Foundation

struct APIResponse: Codable {
    let message: String
}

// Struct to represent the request body, if needed
struct RequestBody<T: Encodable>: Encodable {
    let customData: T

    init(customData: T) {
        self.customData = customData
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(customData)
    }
}

// Dictionary type to represent query parameters, if needed
typealias QueryParameters = [String: String]

// Struct to represent authentication information, if needed
struct Authentication {
    let field: String // The name of the HTTP header field
    let value: String // The value of the header field
}

// Dictionary type to represent custom request headers, if needed
typealias RequestHeaders = [String: String]

enum HTTPMethod {
    case GET, POST, PATCH, PUT, DELETE 
}
