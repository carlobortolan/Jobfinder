//
//  JobModel.swift
//  mobile
//
//  Created by cb on 05.09.23.
//

import Foundation

import Foundation

struct Job: Decodable {
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
    let description: Description
    let keySkills: String
    let salary: Double
    let euroSalary: Double?
    let relevanceScore: Double?
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
    let employerRating: Double
    let jobNotifications: String
    let boost: Int
    let cvRequired: Bool
    let jobValue: String
    let allowedCvFormat: [String]
    let imageUrl: String

    struct Description: Decodable {
        let id: Int
        let name: String
        let body: String
        let recordType: String
        let recordId: Int
        let createdAt: String
        let updatedAt: String
    }
}
