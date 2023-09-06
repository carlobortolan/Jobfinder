//
//  PreferenceModel.swift
//  mobile
//
//  Created by cb on 05.09.23.
//

import Foundation

struct Preferences: Codable {
    let userId: Int
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
    }
}
