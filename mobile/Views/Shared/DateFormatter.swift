//
//  DateFormatter.swift
//  mobile
//
//  Created by cb on 08.09.23.
//

import Foundation

@propertyWrapper
struct DateFormattedISO8601: Codable {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()

    private var date: Date?

    var wrappedValue: Date? {
        get { return date }
        set { date = newValue }
    }

    init(wrappedValue: Date?) {
        self.date = wrappedValue
    }

    init(from decoder: Decoder) throws {
        let dateString = try decoder.singleValueContainer().decode(String.self)
        date = DateFormattedISO8601.dateFormatter.date(from: dateString)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let date = date {
            try container.encode(DateFormattedISO8601.dateFormatter.string(from: date))
        } else {
            try container.encodeNil()
        }
    }
    
}

struct DateParser {
    static func timeRemainingString(from startDate: Date) -> String {
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: currentDate, to: startDate)

        if let years = components.year, years > 0 {
            return "\(years) \(years == 1 ? "year" : "years") and \(components.month ?? 0) \(components.month == 1 ? "month" : "months")"
        } else if let months = components.month, months > 0 {
            return "\(months) \(months == 1 ? "month" : "months") and \(components.day ?? 0) \(components.day == 1 ? "day" : "days")"
        } else if let days = components.day, days > 0 {
            return "\(days) \(days == 1 ? "day" : "days") and \(components.hour ?? 0) \(components.hour == 1 ? "hour" : "hours")"
        } else {
            return "\(components.hour ?? 0) \(components.hour == 1 ? "hour" : "hours") and \(components.minute ?? 0) min"
        }
    }
    
    static func timeRemainingCompactString(from startDate: Date) -> String {
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: currentDate, to: startDate)
        
        if let years = components.year, years > 0 {
            return "\(years) y \(components.month ?? 0) mon"
        } else if let months = components.month, months > 0 {
            return "\(months) mon \(components.day ?? 0) d"
        } else if let days = components.day, days > 0 {
            return "\(days) d \(components.hour ?? 0) h"
        } else {
            return "\(components.hour ?? 0) h \(components.minute ?? 0) min"
        }
    }
    
    static func date(from dateString: String) -> Date? {
        return DateFormattedISO8601.dateFormatter.date(from: dateString)
    }
}
