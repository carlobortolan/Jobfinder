//
//  PreferenceModel.swift
//  mobile
//
//  Created by cb on 05.09.23.
//

import Foundation

struct PreferencesResponse: Codable {
    let preferences: Preferences
}

struct Preferences: Codable {
    let userId: Int
    let interests: String?
    let experience: String?
    let degree: String?
    let numJobsDone: Int
    let gender: String?
    let spontaneity: Double?
    let jobTypes: [String: Int]?
    let keySkills: String?
    let salaryRange: [Double]?
    let cvURL: String?

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case interests
        case experience
        case degree
        case numJobsDone = "num_jobs_done"
        case gender
        case spontaneity
        case jobTypes = "job_types"
        case keySkills = "key_skills"
        case salaryRange = "salary_range"
        case cvURL = "cv_url"
    }
    
    static func generateRandomPreference() -> Preferences {
        let userId = Int.random(in: 1...1000)
        let interests = ["Technology", "Art", "Finance", "Health", "Sports"].randomElement()
        let experience = ["Entry Level", "Mid Level", "Senior"].randomElement()
        let degree = ["High School", "Bachelor's", "Master's", "Ph.D."].randomElement()
        let numJobsDone = Int.random(in: 0...100)
        let gender = ["Male", "Female", "Other"].randomElement()
        let spontaneity = Double.random(in: 0...1)
        let keySkills = ["Communication", "Problem Solving", "Teamwork", "Creativity"].randomElement()
        let salaryRange: [Double] = [Double.random(in: 20000...50000), Double.random(in: 50000...100000)]
        let cvURL = "https://example.com/cv/\(userId)"

        var jobTypes: [String: Int] = [:]
        let jobTypeCount = Int.random(in: 1...5)
        for _ in 1...jobTypeCount {
            let jobType = ["Full-time", "Part-time", "Contract", "Freelance"].randomElement() ?? "Full-time"
            let jobTypeValue = Int.random(in: 1...10)
            jobTypes[jobType] = jobTypeValue
        }

        return Preferences(userId: userId, interests: interests, experience: experience, degree: degree, numJobsDone: numJobsDone, gender: gender, spontaneity: spontaneity, jobTypes: jobTypes.isEmpty ? nil : jobTypes, keySkills: keySkills, salaryRange: salaryRange, cvURL: cvURL)
    }
}
