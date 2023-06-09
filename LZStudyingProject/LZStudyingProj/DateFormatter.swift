//
//  DateFormatter.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/19.
//

import Foundation

extension TimeInterval {
    func convertToString(formatterString: String = "yyyy MM-dd HH:mm") -> String {
        let formatter = DateFormatter()
        let date = Date(timeIntervalSince1970: self)
        formatter.dateFormat = formatterString
        let dateString = formatter.string(from: date)
        return dateString
    }
}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    func adding(days: Int) -> Date {
        var components = DateComponents()
        components.day = days
        return Calendar.current.date(byAdding: components, to: self)!
    }
}
