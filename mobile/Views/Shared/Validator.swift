//
//  Validator.swift
//  mobile
//
//  Created by cb on 08.09.23.
//

import Foundation

class Validator {
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    static func isValidName(_ name: String) -> Bool {
        let nameRegex = "^[a-zA-Z]+(?:[-'\\s][a-zA-Z]+)*$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        return namePredicate.evaluate(with: name)
    }
    
    static func isValidPhone(_ phone: String?) -> Bool {
        if let phone = phone, !phone.isEmpty {
            let phoneRegex = "^[0-9-()\\s]+$"
            let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
            return phonePredicate.evaluate(with: phone)
        } else {
            return true
        }
    }


}
