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
}
