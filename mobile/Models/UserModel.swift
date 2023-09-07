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

struct User: Codable {
    var userId: Int?
    var email: String
    var password: String
    var firstName: String
    var lastName: String
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case password
        case firstName = "first_name"
        case lastName = "last_name"
        case imageUrl = "image_url"
    }
    
    init() {
        self.email = ""
        self.password = ""
        self.firstName = ""
        self.lastName = ""
        self.imageUrl = "https://embloy.onrender.com/assets/img/features_3.png"
    }
    
    // Convert User to JSON
    func toJSON() -> String? {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    // Initialize User from JSON
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
