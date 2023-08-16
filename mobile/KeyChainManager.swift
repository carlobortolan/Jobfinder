//
//  KeyChainManager.swift
//  mobile
//
//  Created by cb on 16.08.23.
//

import Foundation
import Security

struct KeychainManager {
    static func saveToken(_ token: String, forKey key: String) {
         let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: token.data(using: .utf8)!
        ]
        
        SecItemAdd(query as CFDictionary, nil)
        // let status = SecItemAdd(query as CFDictionary, nil)
        // return status == errSecSuccess
    }
    
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
}
