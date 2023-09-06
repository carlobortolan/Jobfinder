//
//  JobModel.swift
//  mobile
//
//  Created by cb on 05.09.23.
//

import Foundation

struct JobResponse: Codable {
    let jobs: [Job]
}

struct Job: Codable {
    let job_id: Int
    let job_type: String
    let job_type_value: Int
    let job_status: Int
    let status: String
    let user_id: Int
    let duration: Int
    let code_lang: String?
    let title: String
    let position: String
    let description: JobDescription
    let key_skills: String
    let salary: Int
    let euro_salary: Int?
    let relevance_score: Int?
    let currency: String
    let start_slot: String
    let longitude: Double
    let latitude: Double
    let country_code: String
    let postal_code: String
    let city: String
    let address: String
    let view_count: Int
    let created_at: String
    let updated_at: String
    let applications_count: Int
    let employer_rating: Int
    let job_notifications: String
    let boost: Int
    let cv_required: Bool
    let job_value: String
    let allowed_cv_format: [String]
    let image_url: String
}

struct JobDescription: Codable {
    let id: Int
    let name: String
    let body: String
    let record_type: String
    let record_id: Int
    let created_at: String
    let updated_at: String
}

class JobModel {
    // Function to generate a random Job object
    static func generateRandomJob() -> Job {
        // You can customize this function to generate random values for each property
        let randomJob = Job(
            job_id: Int.random(in: 1...1000),
            job_type: ["Cleaning", "Retail", "Engineering"].randomElement() ?? "Other",
            job_type_value: Int.random(in: 1...10),
            job_status: Int.random(in: 0...1),
            status: "public",
            user_id: Int.random(in: 1...100),
            duration: Int.random(in: 1...30),
            code_lang: nil,
            title: "Random Job Title",
            position: "Random Position",
            description: JobDescription(
                id: Int.random(in: 1...100),
                name: "description",
                body: "Random job description body",
                record_type: "Job",
                record_id: Int.random(in: 1...100),
                created_at: "2023-09-05T12:45:06.070Z",
                updated_at: "2023-09-05T12:45:06.070Z"
            ),
            key_skills: "Random Key Skills",
            salary: Int.random(in: 20000...100000),
            euro_salary: nil,
            relevance_score: nil,
            currency: "EUR",
            start_slot: "2023-09-07T12:44:00.000Z",
            longitude: Double.random(in: 0...180),
            latitude: Double.random(in: 0...90),
            country_code: "ch",
            postal_code: "8000",
            city: "Random City",
            address: "Random Address",
            view_count: 0,
            created_at: "2023-09-05T12:45:06.070Z",
            updated_at: "2023-09-05T12:45:06.070Z",
            applications_count: Int.random(in: 0...10),
            employer_rating: Int.random(in: 0...5),
            job_notifications: "1",
            boost: Int.random(in: 0...10),
            cv_required: true,
            job_value: "Random Job Value",
            allowed_cv_format: [".pdf", ".docx"],
            image_url: "https://example.com/random_image.jpg"
        )
        
        return randomJob
    }
    
    // Function to generate a random JobResponse object
    static func generateRandomJobResponse() -> JobResponse {
        let randomJobs = (1...5).map { _ in generateRandomJob() }
        return JobResponse(jobs: randomJobs)
    }
}