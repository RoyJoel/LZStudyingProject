//
//  LZUser.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/15.
//
import Alamofire
import CoreLocation
import CryptoKit
import Foundation
import SwiftyJSON
import UIKit

class LZUser {
    // 未登录时为默认信息
    static var user = User()

    static var commodities: [Commodity] = []

    static func signIn(completionHandler: @escaping (User?, Error?) -> Void) {
        // 将要加密的字符串连接在一起
        let password = user.password

        // 计算 SHA256 哈希值
        if let data = password.data(using: .utf8) {
            let hash = SHA256.hash(data: data)
            let hashString = hash.map { String(format: "%02x", $0) }.joined()

            let para = [
                "loginName": user.loginName,
                "password": hashString,
            ]
            LZNetWork.post("/user/signIn", dataParameters: para) { json in
                guard let json = json else {
                    completionHandler(nil, LZNetWorkError.netError("账号或密码错误"))
                    return
                }
                completionHandler(User(json: json), nil)
            }
        }
    }

    static func signUp(completionHandler: @escaping (String?, Error?) -> Void) {
        LZNetWork.post("/user/signUp", dataParameters: LZUser.user, responseBindingType: UserSignUpResponse.self) { response in
            guard let res = response else {
                completionHandler(nil, LZNetWorkError.netError("账号或密码错误"))
                return
            }
            LZUser.user = res.data.user
            completionHandler(LZUser.user.token, nil)
        }
    }

    static func resetPassword(completionHandler: @escaping (Bool) -> Void) {
        let para = [
            "loginName": user.loginName,
            "password": user.password,
        ]
        LZNetWork.post("/user/resetPassword", dataParameters: para) { json in
            guard let json = json else {
                return
            }
            completionHandler(json.boolValue)
        }
    }

    static func updateInfo(completionHandler: @escaping (User?) -> Void) {
        LZNetWork.post("/user/update", dataParameters: LZUser.user) { json in
            guard let json = json else {
                completionHandler(nil)
                return
            }
            LZUser.user = User(json: json)
            completionHandler(LZUser.user)
        }
    }

    static func addFriend(_ friendId: Int, completionHandler: @escaping (Bool) -> Void) {
        let para = [
            "player1Id": user.id,
            "player2Id": friendId,
        ]
        LZNetWork.post("/friend/add", dataParameters: para) { json in
            guard let json = json else {
                completionHandler(false)
                return
            }
            LZUser.user.friends = json.arrayValue.map { Player(json: $0) }
            completionHandler(true)
        }
    }

    static func deleteFriend(_ friendId: Int, completionHandler: @escaping ([Player]) -> Void) {
        let para = [
            "player1Id": user.id,
            "player2Id": friendId,
        ]
        LZNetWork.post("/friend/delete", dataParameters: para) { json in
            guard let json = json else {
                return
            }
            completionHandler(json.arrayValue.map { Player(json: $0) })
        }
    }

    static func getAllFriends(completionHandler: @escaping ([Player]) -> Void) {
        let para = [
            "player1Id": user.id,
        ]
        LZNetWork.post("/friend/getAll", dataParameters: para) { json in
            guard let json = json else {
                return
            }
            completionHandler(json.arrayValue.map { Player(json: $0) })
        }
    }

    static func searchFriend(_ friendId: Int, completionHandler: @escaping (Bool) -> Void) {
        let para = [
            "player1Id": user.id,
            "player2Id": friendId,
        ]
        LZNetWork.post("/friend/search", dataParameters: para) { json in
            guard let json = json else {
                return
            }
            completionHandler(json.boolValue)
        }
    }

    static func getLocationdescription(completionHandler: @escaping (String) -> Void) {
        LZLocationManager.shared.startPositioning { _, location in
            completionHandler(location)
        }
    }

    static func getLocationCoor(completionHandler: @escaping (CLLocation) -> Void) {
        LZLocationManager.shared.startPositioning { location, _ in
            completionHandler(location)
        }
    }

    static func auth(token: String, completionHandler: @escaping (String?, String?, Error?) -> Void) {
        let headers: HTTPHeaders = ["Authorization": token]
        LZNetWork.get("/auth", headers: headers) { json, error in
            guard error == nil else {
                completionHandler(nil, nil, error)
                return
            }
            guard let json = json else {
                completionHandler(nil, nil, nil)
                return
            }
            completionHandler(json["loginName"].stringValue, json["password"].stringValue, nil)
        }
    }

    static func getDeviceID() -> String? {
        if let uuid = UIDevice.current.identifierForVendor {
            return uuid.uuidString
        }
        return nil
    }

    static func getCartInfo(completionHandler: @escaping (Order) -> Void) {
        LZNetWork.post("/cart/getInfo", dataParameters: ["id": LZUser.user.cart]) { json in
            guard let json = json else {
                return
            }
            completionHandler(Order(json: json))
        }
    }

    static func addToCart(bill: BillRequest, completionHandler: @escaping (Order) -> Void) {
        LZNetWork.post("/cart/addBill", dataParameters: bill) { json in
            guard let json = json else {
                return
            }
            completionHandler(Order(json: json))
        }
    }

    static func deleteBillInCart(bill: BillRequest, completionHandler: @escaping (Order) -> Void) {
        LZNetWork.post("/cart/deleteBill", dataParameters: bill) { json in
            guard let json = json else {
                return
            }
            completionHandler(Order(json: json))
        }
    }

    static func assignCart(order: OrderRequest, completionHandler: @escaping (Int) -> Void) {
        LZNetWork.post("/cart/assign", dataParameters: order) { json in
            guard let json = json else {
                return
            }
            LZUser.user.cart = json.intValue
            completionHandler(json.intValue)
        }
    }
}
