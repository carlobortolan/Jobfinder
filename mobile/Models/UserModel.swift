//
//  UserModel.swift
//  mobile
//
//  Created by cb on 06.09.23.
//
//  TODO@IMPORTANT
//  DON'T LOOK AT THE TERRIBLE SPAGHETTI CODE BELOW - THIS SHALL BE FIXED SOON
//  TODO@IMPORTANT
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

struct UserUpdateRequestBody: Encodable {
    let user: UserData

    init(user: User) {
        self.user = UserData(user: user)
    }
}


struct UserData: Encodable {
    let firstName: String?
    let lastName: String?
    let email: String?
    let longitude: Double?
    let latitude: Double?
    let phone: String?
    let degree: String?
    var dateOfBirth: Date?
    let countryCode: String?
    let city: String?
    let postalCode: String?
    let address: String?
    let twitterURL: String?
    let facebookURL: String?
    let linkedinURL: String?
    let instagramURL: String?

    init(user: User) {
        print("UserData - INIT: \(user)")
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.email = user.email
        self.longitude = user.longitude
        self.latitude = user.latitude
        self.phone = user.phone
        self.degree = user.degree
        self.dateOfBirth = user.dateOfBirth
        self.countryCode = user.countryCode
        self.city = user.city
        self.postalCode = user.postalCode
        self.address = user.address
        self.twitterURL = user.twitterURL
        self.facebookURL = user.facebookURL
        self.linkedinURL = user.linkedinURL
        self.instagramURL = user.instagramURL
    }
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
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

    func encode(to encoder: Encoder) throws {
        print("UserData - ENCODE: \(encoder)")
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(email, forKey: .email)
        try container.encodeIfPresent(phone, forKey: .phone)
        try container.encodeIfPresent(degree, forKey: .degree)
        try container.encodeIfPresent(countryCode, forKey: .countryCode)
        try container.encodeIfPresent(city, forKey: .city)
        try container.encodeIfPresent(postalCode, forKey: .postalCode)
        try container.encodeIfPresent(address, forKey: .address)

        if let dateOfBirth = dateOfBirth {
            print("FOO")
            let dateString = DateFormattedISO8601.dateFormatter.string(from: dateOfBirth)
            try container.encodeIfPresent(dateString, forKey: .dateOfBirth)
        } else {
            print("BAR")
            try container.encodeIfPresent("", forKey: .dateOfBirth)
        }

        try container.encodeIfPresent(twitterURL, forKey: .twitterURL)
        try container.encodeIfPresent(facebookURL, forKey: .facebookURL)
        try container.encodeIfPresent(linkedinURL, forKey: .linkedinURL)
        try container.encodeIfPresent(instagramURL, forKey: .instagramURL)
    }

    init(from decoder: Decoder) throws {
        print("UserData - INIT: \(decoder)")
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.longitude = try Double(container.decodeIfPresent(String.self, forKey: .longitude) ?? "0")
        self.latitude = try Double(container.decodeIfPresent(String.self, forKey: .latitude) ?? "0")
        // TODO: Improve in the future
        if let phoneString = try container.decodeIfPresent(String.self, forKey: .phone), !phoneString.isEmpty, phoneString != "0" {
            self.phone = String(format: "%.0f", Double(phoneString) ?? 0)
        } else {
            self.phone = ""
        }
        self.degree = try container.decodeIfPresent(String.self, forKey: .degree)
        let dateString = try container.decodeIfPresent(String.self, forKey: .dateOfBirth)
        if let dateString {
            if dateString.isEmpty {
                self.dateOfBirth = nil
            } else {
                self.dateOfBirth = DateFormattedISO8601.dateFormatter.date(from: dateString)
            }
        }
        self.countryCode = try container.decodeIfPresent(String.self, forKey: .countryCode)
        self.city = try container.decodeIfPresent(String.self, forKey: .city)
        self.postalCode = try container.decodeIfPresent(String.self, forKey: .postalCode)
        self.address = try container.decodeIfPresent(String.self, forKey: .address)
        self.twitterURL = try container.decodeIfPresent(String.self, forKey: .twitterURL)
        self.facebookURL = try container.decodeIfPresent(String.self, forKey: .facebookURL)
        self.linkedinURL = try container.decodeIfPresent(String.self, forKey: .linkedinURL)
        self.instagramURL = try container.decodeIfPresent(String.self, forKey: .instagramURL)
    }
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
    var dateOfBirth: Date?
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
        print("User - INIT")
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
    
    init(userId: Int, email: String, passwordDigest: String, activityStatus: Int, firstName: String, lastName: String, longitude: Double?, latitude: Double?, countryCode: String?, postalCode: String?, city: String?, address: String?, dateOfBirth: Date?, userType: String, viewCount: Int, createdAt: String, updatedAt: String, applicationsCount: Int, jobsCount: Int, userRole: String, applicationNotifications: Bool, twitterURL: String?, facebookURL: String?, instagramURL: String?, linkedinURL: String?, imageURL: String?, phone: String?, degree: String?) {
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
    
    /*func encode(to encoder: Encoder) throws {
        print("FOO1")
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(userId, forKey: .userId)
        try container.encode(email, forKey: .email)
        try container.encode(passwordDigest, forKey: .passwordDigest)
        try container.encode(activityStatus, forKey: .activityStatus)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encodeIfPresent(longitude, forKey: .longitude)
        try container.encodeIfPresent(latitude, forKey: .latitude)
        try container.encodeIfPresent(countryCode, forKey: .countryCode)
        try container.encodeIfPresent(postalCode, forKey: .postalCode)
        try container.encodeIfPresent(city, forKey: .city)
        try container.encodeIfPresent(address, forKey: .address)
        print("FOO2")

        if let dateOfBirth = dateOfBirth {
            print("FOO3")
            let dateString = DateFormattedISO8601.dateFormatter.string(from: dateOfBirth)
            try container.encodeIfPresent(dateString, forKey: .dateOfBirth)
        } else {
            print("BAR")
            try container.encodeIfPresent("", forKey: .dateOfBirth)
        }

        try container.encode(userType, forKey: .userType)
        try container.encode(viewCount, forKey: .viewCount)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encode(applicationsCount, forKey: .applicationsCount)
        try container.encode(jobsCount, forKey: .jobsCount)
        try container.encode(userRole, forKey: .userRole)
        try container.encode(applicationNotifications, forKey: .applicationNotifications)
        try container.encodeIfPresent(twitterURL, forKey: .twitterURL)
        try container.encodeIfPresent(facebookURL, forKey: .facebookURL)
        try container.encodeIfPresent(instagramURL, forKey: .instagramURL)
        try container.encodeIfPresent(linkedinURL, forKey: .linkedinURL)
        try container.encodeIfPresent(imageURL, forKey: .imageURL)
        try container.encodeIfPresent(phone, forKey: .phone)
        try container.encodeIfPresent(degree, forKey: .degree)
    }
    */
    
    init(from decoder: Decoder) throws {
        print("User - INIT: \(decoder)")
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        userId = try container.decode(Int.self, forKey: .userId)
        email = try container.decode(String.self, forKey: .email)
        passwordDigest = try container.decode(String.self, forKey: .passwordDigest)
        activityStatus = try container.decode(Int.self, forKey: .activityStatus)
        firstName = try container.decode(String.self, forKey: .firstName)
        lastName = try container.decode(String.self, forKey: .lastName)
        longitude = try container.decodeIfPresent(Double.self, forKey: .longitude)
        latitude = try container.decodeIfPresent(Double.self, forKey: .latitude)
        countryCode = try container.decodeIfPresent(String.self, forKey: .countryCode)
        postalCode = try container.decodeIfPresent(String.self, forKey: .postalCode)
        city = try container.decodeIfPresent(String.self, forKey: .city)
        address = try container.decodeIfPresent(String.self, forKey: .address)

        let dateString = try container.decodeIfPresent(String.self, forKey: .dateOfBirth)
        if let dateString {
            if dateString.isEmpty {
                self.dateOfBirth = nil
            } else {
                self.dateOfBirth = DateFormattedISO8601.dateFormatter.date(from: dateString)
            }
        }

        userType = try container.decode(String.self, forKey: .userType)
        viewCount = try container.decode(Int.self, forKey: .viewCount)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)
        applicationsCount = try container.decode(Int.self, forKey: .applicationsCount)
        jobsCount = try container.decode(Int.self, forKey: .jobsCount)
        userRole = try container.decode(String.self, forKey: .userRole)
        applicationNotifications = try container.decode(Bool.self, forKey: .applicationNotifications)
        twitterURL = try container.decodeIfPresent(String.self, forKey: .twitterURL)
        facebookURL = try container.decodeIfPresent(String.self, forKey: .facebookURL)
        instagramURL = try container.decodeIfPresent(String.self, forKey: .instagramURL)
        linkedinURL = try container.decodeIfPresent(String.self, forKey: .linkedinURL)
        imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        // TODO: Improve in the future
        if let phoneString = try container.decodeIfPresent(String.self, forKey: .phone), !phoneString.isEmpty, phoneString != "0" {
            self.phone = String(format: "%.0f", Double(phoneString) ?? 0)
        } else {
            self.phone = ""
        }
        degree = try container.decodeIfPresent(String.self, forKey: .degree)
    }

    func toJSON() -> String? {
        print("User - TO JSON")
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormattedISO8601.dateFormatter)
        
        if let data = try? encoder.encode(self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    static func fromJSON(_ jsonString: String) -> User? {
    print("User - FROM JSON: \(jsonString)")
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(DateFormattedISO8601.dateFormatter)
    
    if let data = jsonString.data(using: .utf8) {
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
        let dateOfBirth = Date.distantFuture
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
