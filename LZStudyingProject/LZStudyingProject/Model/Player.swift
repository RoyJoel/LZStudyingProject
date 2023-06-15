//
//  Player.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/2/25.
//

import Foundation
import SwiftyJSON

struct Player: Codable, Equatable {
    var id: Int
    var loginName: String
    var name: String
    var icon: String
    var sex: Sex
    var age: Int
    var points: Int
    var isAdult: Bool

    init(id: Int, loginName: String, name: String, icon: String, sex: Sex, age: Int, points: Int, isAdult: Bool) {
        self.id = id
        self.loginName = loginName
        self.name = name
        self.icon = icon
        self.sex = sex
        self.age = age
        self.points = points
        self.isAdult = isAdult
    }

    init(json: JSON) {
        id = json["id"].intValue
        loginName = json["loginName"].stringValue
        name = json["name"].stringValue
        icon = json["icon"].stringValue
        sex = Sex(rawValue: json["sex"].stringValue) ?? .Man
        age = json["age"].intValue
        points = json["points"].intValue
        isAdult = json["isAdult"].boolValue
    }

    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? Int,
            let loginName = dictionary["loginName"] as? String,
            let name = dictionary["name"] as? String,
            let icon = dictionary["icon"] as? String,
            let sexRawValue = dictionary["sex"] as? String,
            let sex = Sex(rawValue: sexRawValue),
            let age = dictionary["age"] as? Int,
            let points = dictionary["points"] as? Int,
            let isAdult = dictionary["isAdult"] as? Bool else {
            return nil
        }

        self.init(id: id, loginName: loginName, name: name, icon: icon, sex: sex, age: age, points: points, isAdult: isAdult)
    }

    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "loginName": loginName,
            "name": name,
            "icon": icon,
            "sex": sex.rawValue,
            "age": age,
            "points": points,
            "isAdult": isAdult
        ]
    }

    init() {
        self = Player(json: JSON())
    }

    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.id == rhs.id &&
            lhs.loginName == rhs.loginName &&
            lhs.name == rhs.name &&
            lhs.icon == rhs.icon &&
            lhs.sex == rhs.sex &&
            lhs.age == rhs.age &&
            lhs.points == rhs.points &&
            lhs.isAdult == rhs.isAdult
    }
}
