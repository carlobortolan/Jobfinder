//
//  UserModel.swift
//  mobile
//
//  Created by cb on 06.09.23.
//

import Foundation

struct User: Codable {
    let userId: Int
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
