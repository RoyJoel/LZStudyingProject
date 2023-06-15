//
//  LZDataConvert.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/6.
//

import Foundation

class LZDataConvert {
    
    static func changePosition(with value1: inout Int, and value2: inout Int) {
        let t = value1
        value1 = value2
        value2 = t
    }

    static func Divide(_ dividend: Int, by divisor: Int) -> Double {
        if divisor == 0 {
            return 0
        } else {
            return Double(dividend) / Double(divisor)
        }
    }

    static func datesInRangeString(startDate: TimeInterval, endDate: TimeInterval) -> (schedules: [String], nowIndex: Int) {
        let calendar = Calendar.current
        let startDate = Date(timeIntervalSince1970: startDate)
        var currentDate = startDate
        let endDate = Date(timeIntervalSince1970: endDate).startOfDay.adding(days: 1)

        var dates: [String] = []
        var index: Int = 0
        var res: Int = 0
        while currentDate < endDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd"
            let dateString = dateFormatter.string(from: currentDate)
            if currentDate.endOfDay >= Date(), Date() >= currentDate.startOfDay {
                dates.insert(dateString, at: 0)
                res = index
            } else {
                dates.append(dateString)
            }
            index += 1
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }

        return (dates, res)
    }

    static func getTotalPrice(_ bills: [Bill]) -> Double {
        var price: Double = 0
        for bill in bills {
            price += bill.option.price * Double(bill.quantity)
        }
        return price
    }

    static func getPriceRange(with options: [Option]) -> (Double, Double) {
        var max = Double(Int.min)
        var min = Double(Int.max)

        for option in options {
            if option.price > max {
                max = option.price
            }
            if option.price < min {
                min = option.price
            }
        }

        return (min, max)
    }

    static func getTotalInventory(with options: [Option]) -> Int {
        var inventory = 0
        for option in options {
            inventory += option.inventory
        }
        return inventory
    }
}
