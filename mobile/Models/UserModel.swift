//
//  UserModel.swift
//  mobile
//
//  Created by cb on 06.09.23.
//

import Foundation

struct UserResponse: Codable {
    let user: User
}

struct RefreshTokenResponse: Codable {
    let refresh_token: String
}

struct AccessTokenResponse: Codable {
    let access_token: String
}

struct User: Codable {
    let userId: Int
    var email: String
    var passwordDigest: String
    var activityStatus: Int
    var firstName: String
    var lastName: String
    var longitude: Double?
    var latitude: Double?
    var countryCode: String?
    var postalCode: String?
    var city: String?
    var address: String?
    var dateOfBirth: String?
    var userType: String
    var viewCount: Int
    var createdAt: String
    var updatedAt: String
    var applicationsCount: Int
    var jobsCount: Int
    var userRole: String
    var applicationNotifications: Bool
    var twitterURL: String?
    var facebookURL: String?
    var instagramURL: String?
    var linkedinURL: String?
    var imageURL: String?
    var phone: String?
    var degree: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "id"
        case email
        case passwordDigest = "password_digest"
        case activityStatus = "activity_status"
        case firstName = "first_name"
        case lastName = "last_name"
        case longitude
        case latitude
        case countryCode = "country_code"
        case postalCode = "postal_code"
        case city
        case address
        case dateOfBirth = "date_of_birth"
        case userType = "user_type"
        case viewCount = "view_count"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case applicationsCount = "applications_count"
        case jobsCount = "jobs_count"
        case userRole = "user_role"
        case applicationNotifications = "application_notifications"
        case twitterURL = "twitter_url"
        case facebookURL = "facebook_url"
        case instagramURL = "instagram_url"
        case linkedinURL = "linkedin_url"
        case imageURL = "image_url"
        case phone
        case degree
    }

    init() {
        self.userId = 0
        self.email = ""
        self.passwordDigest = ""
        self.activityStatus = 0
        self.firstName = ""
        self.lastName = ""
        self.longitude = nil
        self.latitude = nil
        self.countryCode = nil
        self.postalCode = nil
        self.city = nil
        self.address = nil
        self.dateOfBirth = nil
        self.userType = ""
        self.viewCount = 0
        self.createdAt = ""
        self.updatedAt = ""
        self.applicationsCount = 0
        self.jobsCount = 0
        self.userRole = ""
        self.applicationNotifications = false
        self.twitterURL = nil
        self.facebookURL = nil
        self.instagramURL = nil
        self.linkedinURL = nil
        self.imageURL = "https://embloy.onrender.com/assets/img/features_3.png"
        self.phone = nil
        self.degree = nil
        }

    init(userId: Int, email: String, passwordDigest: String, activityStatus: Int, firstName: String, lastName: String, longitude: Double?, latitude: Double?, countryCode: String?, postalCode: String?, city: String?, address: String?, dateOfBirth: String?, userType: String, viewCount: Int, createdAt: String, updatedAt: String, applicationsCount: Int, jobsCount: Int, userRole: String, applicationNotifications: Bool, twitterURL: String?, facebookURL: String?, instagramURL: String?, linkedinURL: String?, imageURL: String?, phone: String?, degree: String?) {
        self.userId = userId
        self.email = email
        self.passwordDigest = passwordDigest
        self.activityStatus = activityStatus
        self.firstName = firstName
        self.lastName = lastName
        self.longitude = longitude
        self.latitude = latitude
        self.countryCode = countryCode
        self.postalCode = postalCode
        self.city = city
        self.address = address
        self.dateOfBirth = dateOfBirth
        self.userType = userType
        self.viewCount = viewCount
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.applicationsCount = applicationsCount
        self.jobsCount = jobsCount
        self.userRole = userRole
        self.applicationNotifications = applicationNotifications
        self.twitterURL = twitterURL
        self.facebookURL = facebookURL
        self.instagramURL = instagramURL
        self.linkedinURL = linkedinURL
        self.imageURL = imageURL
        self.phone = phone
        self.degree = degree
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
    
    static func generateRandomUser() -> User {
        let userId = Int.random(in: 1...1000)
        let email = "\(userId)@example.com"
        let passwordDigest = "RandomPasswordDigest\(userId)"
        let activityStatus = 1
        let firstName = ["John", "Jane", "Alex", "Emily"].randomElement() ?? "John"
        let lastName = ["Doe", "Smith", "Johnson", "Brown"].randomElement() ?? "Doe"
        let longitude = Double.random(in: -180.0...180.0)
        let latitude = Double.random(in: -90.0...90.0)
        let countryCode = "US"
        let postalCode = "12345"
        let city = "Sample City"
        let address = "123 Main St"
        let dateOfBirth = "1990-01-01"
        let userType = "private"
        let viewCount = Int.random(in: 1...100)
        let createdAt = "2023-09-07T11:39:50.168Z"
        let updatedAt = "2023-09-07T11:39:50.168Z"
        let applicationsCount = Int.random(in: 0...50)
        let jobsCount = Int.random(in: 0...20)
        let userRole = "verified"
        let applicationNotifications = true
        let twitterURL = "https://twitter.com/\(firstName)\(lastName)"
        let facebookURL = "https://www.facebook.com/\(firstName)\(lastName)"
        let instagramURL = "https://www.instagram.com/\(firstName)\(lastName)"
        let phone = "+1 123-456-7890"
        let degree = "Bachelor's Degree in Computer Science"
        let linkedinURL = "https://www.linkedin.com/in/\(firstName)\(lastName)"
        let imageURL = "https://f005.backblazeb2.com/file/TestEmbloy/qpew2qrgj79r6vnrn5g9r0k0dkyk?Authorization=3_20230906105048_88964a7efef142dda956c4dd_cda0284ea7abf86a4035a68ca856f843216154a4_005_20230913105048_0028_dnld"
        
        return User(userId: userId, email: email, passwordDigest: passwordDigest, activityStatus: activityStatus, firstName: firstName, lastName: lastName, longitude: longitude, latitude: latitude, countryCode: countryCode, postalCode: postalCode, city: city, address: address, dateOfBirth: dateOfBirth, userType: userType, viewCount: viewCount, createdAt: createdAt, updatedAt: updatedAt, applicationsCount: applicationsCount, jobsCount: jobsCount, userRole: userRole, applicationNotifications: applicationNotifications, twitterURL: twitterURL, facebookURL: facebookURL, instagramURL: instagramURL, linkedinURL: linkedinURL, imageURL: imageURL, phone: phone, degree: degree)
    }
}
