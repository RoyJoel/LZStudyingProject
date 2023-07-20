//
//  logo.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/19.
//

import Foundation
import SwiftyJSON

struct AnimeInfo: Codable, Equatable {
    var id: String
    var bg: String
    var year: Int
    var month: Int
    var title: String
    var atime: TimeInterval
    var desc: String
    var logo: String
    
    init(id: String, bg: String, title: String, year: Int, month: Int, atime: TimeInterval, desc: String, logo: String) {
        self.id = id
        self.bg = bg
        self.title = title
        self.year = year
        self.month = month
        self.atime = atime
        self.desc = desc
        self.logo = logo
    }
    
    init(json: JSON) {
        id = json["id"].stringValue
        bg = json["bg"].stringValue
        title = json["title"].stringValue
        year = json["year"].intValue
        month = json["month"].intValue
        atime = json["atime"].doubleValue
        desc = json["desc"].stringValue
        logo = json["logo"].stringValue
    }

    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
            let bg = dictionary["bg"] as? String,
            let title = dictionary["title"] as? String,
            let year = dictionary["year"] as? Int,
              let month = dictionary["month"] as? Int,
            let atime = dictionary["atime"] as? TimeInterval,
            let desc = dictionary["desc"] as? String,
            let logo = dictionary["logo"] as? String else {
            return nil
        }

        self.init(id: id, bg: bg, title: title, year: year, month: month, atime: atime, desc: desc, logo: logo)
    }
    
    init() {
        self = AnimeInfo(json: JSON())
    }

    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "bg": bg,
            "title": title,
            "year": year,
            "month": month,
            "atime": atime,
            "desc": desc,
            "logo": logo,
        ]
    }

    static func == (lhs: AnimeInfo, rhs: AnimeInfo) -> Bool {
        return lhs.id == rhs.id &&
            lhs.bg == rhs.bg &&
            lhs.title == rhs.title &&
            lhs.year == rhs.year &&
        lhs.month == rhs.month &&
            lhs.atime == rhs.atime &&
            lhs.desc == rhs.desc &&
            lhs.logo == rhs.logo
    }
}


struct AnimeInfoData: Codable, Equatable {
    var id: String
    var bg: [String: Data]
    var year: Int
    var month: Int
    var title: String
    var atime: TimeInterval
    var desc: String
    var logo: [String: Data]
    
    init(id: String, bg: [String: Data], year: Int, month: Int, title: String, atime: TimeInterval, desc: String, logo: [String: Data]) {
        self.id = id
        self.bg = bg
        self.year = year
        self.month = month
        self.title = title
        self.atime = atime
        self.desc = desc
        self.logo = logo
    }
    
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let bg = dictionary["bg"] as? [String: Data],
            let title = dictionary["title"] as? String,
            let year = dictionary["year"] as? Int,
              let month = dictionary["month"] as? Int,
            let atime = dictionary["atime"] as? TimeInterval,
            let desc = dictionary["desc"] as? String,
            let logo = dictionary["logo"] as? [String: Data] else {
            return nil
        }

        self.init(id: id, bg: bg, year: year, month: month, title: title, atime: atime, desc: desc, logo: logo)
    }

    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "bg": bg,
            "title": title,
            "year": year,
            "month": month,
            "atime": atime,
            "desc": desc,
            "logo": logo,
        ]
    }

    static func == (lhs: AnimeInfoData, rhs: AnimeInfoData) -> Bool {
        return lhs.id == rhs.id &&
            lhs.bg == rhs.bg &&
            lhs.title == rhs.title &&
            lhs.year == rhs.year &&
        lhs.month == rhs.month &&
            lhs.atime == rhs.atime &&
            lhs.desc == rhs.desc &&
            lhs.logo == rhs.logo
    }
}
