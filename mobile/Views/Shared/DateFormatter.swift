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
