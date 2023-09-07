//
//  ApplicationModel.swift
//  mobile
//
//  Created by cb on 05.09.23.
//

import Foundation

struct ApplicationResponse: Codable {
    let applications: [Application]
}

struct Application: Codable, Hashable {
    let jobId: Int
    let userId: Int
    let createdAt: Date
    let updatedAt: Date
    let status: String
    let applicationText: String
    let applicationDocuments: String
    let response: String

    enum CodingKeys: String, CodingKey {
        case jobId = "job_id"
        case userId = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case status
        case applicationText = "application_text"
        case applicationDocuments = "application_documents"
        case response
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine("\(jobId)-\(userId)")
    }
    
    static func == (lhs: Application, rhs: Application) -> Bool {
        return lhs.jobId == rhs.jobId && lhs.userId == rhs.userId
    }
}
