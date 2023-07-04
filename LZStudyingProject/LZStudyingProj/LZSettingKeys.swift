//
//  LZSettingKeys.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/6.
//

import Foundation

enum AppearanceSetting: String {
    case Light
    case Dark
    case UnSpecified

    var userDisplayName: String {
        switch self {
        case .Light: return "始终浅色"
        case .Dark: return "始终深色"
        case .UnSpecified: return "跟随系统"
        }
    }

    var code: String {
        switch self {
        case .UnSpecified: return "0"
        case .Light: return "1"
        case .Dark: return "2"
        }
    }

    init(userDisplayName: String) {
        switch userDisplayName {
        case "始终浅色": self = .Light
        case "始终深色": self = .Dark
        case "跟随系统": self = .UnSpecified
        default:
            self = .UnSpecified
        }
    }

    init(code: String) {
        switch code {
        case "1": self = .Light
        case "2": self = .Dark
        case "0": self = .UnSpecified
        default:
            self = .UnSpecified
        }
    }
}

enum LanguageSetting: String {
    case Ch = "zh-Hans"
    case En = "en"
    case Fr = "fr"
    case Es = "es"
    case De = "de"

    var userDisplayName: String {
        switch self {
        case .Ch: return "Chinese"
        case .En: return "English"
        case .Fr: return "French"
        case .Es: return "Spanish"
        case .De: return "German"
        }
    }

    init(userDisplayName: String) {
        switch userDisplayName {
        case "Chinese": self = .Ch
        case "English": self = .En
        case "French": self = .Fr
        case "Spanish": self = .Es
        case "German": self = .De
        default:
            self = .Ch
        }
    }
}
