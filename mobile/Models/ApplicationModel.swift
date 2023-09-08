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
    let createdAt: String
    let updatedAt: String
    let status: String
    let applicationText: String
    let applicationDocuments: String?
    let response: String?

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
    
    static func generateRandomApplication() -> Application {
        return Application(
            jobId: Int.random(in: 0...10),
            userId: Int.random(in: 0...10),
            createdAt: "2023-09-05T12:45:06.070Z",
            updatedAt: "2023-09-05T12:45:06.070Z",
            status: ["Pending", "Accepted", "Rejected"].randomElement()!,
            applicationText: "This is an application",
            applicationDocuments: nil,
            response: nil
        )
    }
    
    static func generateRandomApplications() -> ApplicationResponse {
        let randomApplications = (1...5).map { _ in generateRandomApplication() }
        return ApplicationResponse(applications: randomApplications)
    }
    
    func toJSON() -> String? {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    static func fromJSON(_ jsonString: String) -> User? {
        if let data = jsonString.data(using: .utf8) {
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(User.self, from: data) {
                return user
            }
        }
        return nil
    }

}
