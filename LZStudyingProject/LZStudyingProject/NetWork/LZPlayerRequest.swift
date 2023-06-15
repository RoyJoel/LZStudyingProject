//
//  LZRequest.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/2/28.
//

import Alamofire
import Foundation
import SwiftyJSON

class LZPlayerRequest {
    static func addPlayer(player: Player, completionHandler: @escaping (Player) -> Void) {
        let para = [
            "id": player.id,
            "loginName": player.loginName,
            "name": player.name,
            "icon": player.icon,
            "sex": player.sex.rawValue,
            "age": player.age,
            "points": player.points,
            "isAdult": player.isAdult
        ] as [String : Any]

        LZNetWork.post("/player/add", dataParameters: para) { json in
            guard let json = json else {
                return
            }
            completionHandler(Player(json: json))
        }
    }

    static func getInfo(loginName: String, completionHandler: @escaping (Player?) -> Void) {
        let para = [
            "loginName": loginName,
        ]
        LZNetWork.post("/player/getInfo", dataParameters: para) { json in
            guard let json = json else {
                completionHandler(nil)
                return
            }
            completionHandler(Player(json: json))
        }
    }

    static func searchPlayer(loginName: String, completionHandler: @escaping (Bool) -> Void) {
        let para = [
            "loginName": loginName,
        ]
        LZNetWork.post("/player/search", dataParameters: para) { json in
            guard let json = json else {
                return
            }
            completionHandler(json.boolValue)
        }
    }

    static func updatePlayer(player: Player, completionHandler: @escaping (Player) -> Void) {
        let para = [
            "id": player.id,
            "loginName": player.loginName,
            "name": player.name,
            "icon": player.icon,
            "sex": player.sex.rawValue,
            "age": player.age,
            "points": player.points,
            "isAdult": player.isAdult,
        ] as! [String: Any]

        LZNetWork.post("/player/update", dataParameters: para) { json in
            guard let json = json else {
                return
            }
            completionHandler(Player(json: json))
        }
    }
}
