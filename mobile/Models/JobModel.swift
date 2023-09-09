//
//  JobModel.swift
//  mobile
//
//  Created by cb on 05.09.23.
//

import Foundation

struct JobsResponse: Codable {
    let jobs: [Job]
}

struct FeedResponse: Codable {
    let feed: [Job]
}

struct Job: Codable, Hashable {
    let jobId: Int
    let jobType: String
    let jobTypeValue: Int
    let jobStatus: Int
    let status: String
    let userId: Int
    let duration: Int
    let codeLang: String?
    let title: String
    let position: String
    let description: JobDescription
    let keySkills: String
    let salary: Int
    let euroSalary: Int?
    let relevanceScore: Int?
    let currency: String
    let startSlot: String
    let longitude: Double
    let latitude: Double
    let countryCode: String
    let postalCode: String
    let city: String
    let address: String
    let viewCount: Int
    let createdAt: String
    let updatedAt: String
    let applicationsCount: Int
    let employerRating: Int
    let jobNotifications: String
    let boost: Int
    let cvRequired: Bool
    let jobValue: String
    let allowedCvFormat: [String]
    let imageUrl: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(jobId)
    }

    static func == (lhs: Job, rhs: Job) -> Bool {
        return lhs.jobId == rhs.jobId
    }

    enum CodingKeys: String, CodingKey {
        case jobId = "job_id"
        case jobType = "job_type"
        case jobTypeValue = "job_type_value"
        case jobStatus = "job_status"
        case status
        case userId = "user_id"
        case duration
        case codeLang = "code_lang"
        case title
        case position
        case description
        case keySkills = "key_skills"
        case salary
        case euroSalary = "euro_salary"
        case relevanceScore = "relevance_score"
        case currency
        case startSlot = "start_slot"
        case longitude
        case latitude
        case countryCode = "country_code"
        case postalCode = "postal_code"
        case city
        case address
        case viewCount = "view_count"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case applicationsCount = "applications_count"
        case employerRating = "employer_rating"
        case jobNotifications = "job_notifications"
        case boost
        case cvRequired = "cv_required"
        case jobValue = "job_value"
        case allowedCvFormat = "allowed_cv_format"
        case imageUrl = "image_url"
    }
}

struct JobDescription: Codable {
    let id: Int
    let name: String
    let body: String
    let recordType: String
    let recordId: Int
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case body
        case recordType = "record_type"
        case recordId = "record_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

class JobModel {
    static func generateRandomJob() -> Job {
        let randomJob = Job(
            jobId: Int.random(in: 1...1000),
            jobType: ["Cleaning", "Retail", "Engineering"].randomElement() ?? "Other",
            jobTypeValue: Int.random(in: 1...10),
            jobStatus: Int.random(in: 0...1),
            status: "public",
            userId: Int.random(in: 1...100),
            duration: Int.random(in: 1...30),
            codeLang: nil,
            title: "Random Job Title",
            position: "Random Position",
            description: JobDescription(
                id: Int.random(in: 1...100),
                name: "description",
                body: "Random job description body",
                recordType: "Job",
                recordId: Int.random(in: 1...100),
                createdAt: "2023-09-05T12:45:06.070Z",
                updatedAt: "2023-09-05T12:45:06.070Z"
            ),
            keySkills: "Random Key Skills",
            salary: Int.random(in: 20000...100000),
            euroSalary: nil,
            relevanceScore: nil,
            currency: "EUR",
            startSlot: "2023-09-07T12:44:00.000Z",
            longitude: Double.random(in: 0...180),
            latitude: Double.random(in: 0...90),
            countryCode: "ch",
            postalCode: "8000",
            city: "Random City",
            address: "Random Address",
            viewCount: 0,
            createdAt: "2023-09-05T12:45:06.070Z",
            updatedAt: "2023-09-05T12:45:06.070Z",
            applicationsCount: Int.random(in: 0...10),
            employerRating: Int.random(in: 0...5),
            jobNotifications: "1",
            boost: Int.random(in: 0...10),
            cvRequired: true,
            jobValue: "Random Job Value",
            allowedCvFormat: [".pdf", ".docx"],
            imageUrl: "https://cdn.mos.cms.futurecdn.net/ohsXtgy8Hmi9PzDNpKhJ5N.jpg"
        )
        return randomJob
    }
    
    static func generateRandomJobsResponse() -> JobsResponse {
        let randomJobs = (1...5).map { _ in generateRandomJob() }
        return JobsResponse(jobs: randomJobs)
    }

    static func generateRandomFeedResponse() -> FeedResponse {
        let randomJobs = (1...5).map { _ in generateRandomJob() }
        return FeedResponse(feed: randomJobs)
    }
}
