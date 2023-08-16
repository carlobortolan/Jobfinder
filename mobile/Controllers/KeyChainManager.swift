//
//  KeyChainManager.swift
//  mobile
//
//  Created by cb on 16.08.23.
//

import Foundation
import Security

struct KeychainManager {
    
    static func loadToken(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let data = result as? Data {
            return String(data: data, encoding: .utf8)
        } else {
            return nil
        }
    }

    static func saveOrUpdateToken(_ token: String, forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: token.data(using: .utf8)!
        ]

        let status = SecItemCopyMatching(query as CFDictionary, nil)
        
        switch status {
        case errSecSuccess:
            // Token already exists, update it
            let attributesToUpdate: [String: Any] = [
                kSecValueData as String: token.data(using: .utf8)!
            ]
            
            let updateStatus = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            if updateStatus != errSecSuccess {
                print("Error updating token: \(updateStatus)")
            }
            
        case errSecItemNotFound:
            // Token doesn't exist, save it
            let addStatus = SecItemAdd(query as CFDictionary, nil)
            if addStatus != errSecSuccess {
                print("Error adding token: \(addStatus)")
            }
            
        default:
            print("Error querying token status: \(status)")
        }
    }
}
