//
//  Commodity.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/21.
//

import Foundation
import SwiftyJSON

struct Commodity: Codable, Equatable {
    var id: Int
    var name: String
    var intro: String
    var orders: Int
    var options: [Option]
    var cag: ComCag
    var state: CommodityState

    init(id: Int, options: [Option], name: String, intro: String, orders: Int, cag: ComCag, state: CommodityState) {
        self.id = id
        self.options = options
        self.name = name
        self.intro = intro
        self.orders = orders
        self.cag = cag
        self.state = state
    }

    init(json: JSON) {
        id = json["id"].intValue
        options = json["options"].arrayValue.compactMap { Option(json: $0) }
        name = json["name"].stringValue
        intro = json["intro"].stringValue
        orders = json["orders"].intValue
        cag = ComCag(rawValue: json["cag"].intValue) ?? .Accessories
        state = CommodityState(rawValue: json["state"].intValue) ?? .ToArrived
    }
    
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? Int, let optiondits = dictionary["options"] as? [[String: Any]], let name = dictionary["name"] as? String, let intro = dictionary["intro"] as? String, let orders = dictionary["orders"] as? Int, let cag = dictionary["cag"] as? Int, let stateRawValue = dictionary["state"] as? Int else {
            return nil
        }

        let options = optiondits.map { Option(dictionary: $0) ?? Option() }
        let comcag = ComCag(rawValue: cag) ?? .Accessories
        let state = CommodityState(rawValue: stateRawValue) ?? .ToArrived
        self = Commodity(id: id, options: options, name: name, intro: intro, orders: orders, cag: comcag, state: state)
    }

    init() {
        self = Commodity(json: JSON())
    }

    func toDictionary() -> [String: Any] {
        let dict: [String: Any] = [
            "id": id,
            "options": options,
            "name": name,
            "intro": intro,
            "orders": orders,
            "cag": cag,
            "state": state.rawValue,
        ]
        return dict
    }

    static func == (lhs: Commodity, rhs: Commodity) -> Bool {
        return lhs.id == rhs.id && lhs.options == rhs.options && lhs.name == rhs.name && lhs.intro == rhs.intro && lhs.orders == rhs.orders && lhs.cag == rhs.cag && lhs.state == rhs.state
    }
}
