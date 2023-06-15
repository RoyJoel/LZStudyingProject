//
//  ComPoint.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/15.
//

import Foundation

enum ComPoint: Int, Codable, CaseIterable {
    case none = 0
    case small = 1
    case med = 2
    case medWell = 3
    case wellDone = 4

    var displayName: String {
        switch self {
        case .none:
            return "不限"
        case .small:
            return "<100"
        case .med:
            return "100-500"
        case .medWell:
            return "500-1000"
        case .wellDone:
            return ">1000"
        }
    }

    init(displayName: String) {
        switch displayName {
        case ">1000":
            self = .wellDone
        case "500-1000":
            self = .medWell
        case "100-500":
            self = .med
        case "<100":
            self = .small
        default:
            self = .none
        }
    }
}
