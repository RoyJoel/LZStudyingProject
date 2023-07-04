//
//  User.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/15.
//

import Foundation
import SwiftyJSON

struct User: Codable, Equatable {
    var id: Int
    var loginName: String
    var password: String
    var name: String
    var icon: String
    var sex: Sex
    var age: Int
    var points: Int
    var friends: [Player]
    var allLikedMusic: [String]
    var addresss: [Int]
    var allOrders: [Int]
    var cart: Int
    var defaultAddress: Address
    var token: String

    init(id: Int, loginName: String, password: String, name: String, icon: String, sex: Sex, age: Int, points: Int, friends: [Player], allLikedMusic: [String], addresss: [Int], allOrders: [Int], cart: Int, defaultAddress: Address, token: String) {
        self.id = id
        self.loginName = loginName
        self.password = password
        self.name = name
        self.icon = icon
        self.sex = sex
        self.age = age
        self.points = points
        self.friends = friends
        self.allLikedMusic = allLikedMusic
        self.addresss = addresss
        self.allOrders = allOrders
        self.cart = cart
        self.defaultAddress = defaultAddress
        self.token = token
    }

    init(json: JSON) {
        id = json["id"].intValue
        loginName = json["loginName"].stringValue
        password = json["password"].stringValue
        name = json["name"].stringValue
        icon = json["icon"].stringValue
        sex = Sex(rawValue: json["sex"].stringValue) ?? .Man
        age = json["age"].intValue
        points = json["points"].intValue
        friends = json["friends"].arrayValue.map { Player(json: $0) }
        allLikedMusic = json["allLikedMusic"].arrayValue.map { $0.stringValue }
        addresss = json["addresss"].arrayValue.map { $0.intValue }
        allOrders = json["allOrders"].arrayValue.map { $0.intValue }
        cart = json["cart"].intValue
        defaultAddress = Address(json: json["defaultAddress"])
        token = json["token"].stringValue
    }
    
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? Int,
            let loginName = dictionary["loginName"] as? String,
            let password = dictionary["password"] as? String,
            let name = dictionary["name"] as? String,
            let icon = dictionary["icon"] as? String,
            let sexRawValue = dictionary["sex"] as? String,
            let sex = Sex(rawValue: sexRawValue),
            let age = dictionary["age"] as? Int,
            let points = dictionary["points"] as? Int,
            let friendsDictionaries = dictionary["friends"] as? [[String: Any]],
            let allLikedMusic = dictionary["allLikeMusic"] as? [String],
            let addresssDictionaries = dictionary["addresss"] as? [Int],
            let ordersDictionaries = dictionary["allOrders"] as? [Int],
            let cartDictionaries = dictionary["cart"] as? Int,
            let defaultAddressDictionaries = dictionary["defaultAddress"] as? [String: Any],
            let token = dictionary["token"] as? String
        else {
            return nil
        }
        let friends = friendsDictionaries.compactMap { Player(dictionary: $0) }
        let defaultAddress = Address(dictionary: defaultAddressDictionaries)

        self = User(id: id, loginName: loginName, password: password, name: name, icon: icon, sex: sex, age: age, points: points, friends: friends, allLikedMusic: allLikedMusic, addresss: addresssDictionaries, allOrders: ordersDictionaries, cart: cartDictionaries, defaultAddress: defaultAddress ?? Address(), token: token)
    }

    init() {
        self = User(json: JSON())
    }

    func toDictionary() -> [String: Any] {
        let dict: [String: Any] = [
            "id": id,
            "loginName": loginName,
            "password": password,
            "name": name,
            "icon": icon,
            "sex": sex.rawValue,
            "age": age,
            "points": points,
            "friends": friends.map({ $0.toDictionary() }),
            "allLikedMusic": allLikedMusic,
            "addresss": addresss,
            "allOrders": allOrders,
            "cart": cart,
            "defaultAddress": defaultAddress.toDictionary(),
            "token": token,
        ]

        return dict
    }

    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id &&
            lhs.loginName == rhs.loginName &&
            lhs.password == rhs.password &&
            lhs.name == rhs.name &&
            lhs.icon == rhs.icon &&
            lhs.sex == rhs.sex &&
            lhs.age == rhs.age &&
            lhs.points == rhs.points &&
            lhs.friends == rhs.friends &&
        lhs.allLikedMusic == rhs.allLikedMusic &&
            lhs.addresss == rhs.addresss && lhs.allOrders == rhs.allOrders && lhs.defaultAddress == rhs.defaultAddress && lhs.cart == rhs.cart
    }
}

struct signupResponse: Codable {
    var user: User
    var res: Bool
}

struct UserSignUpResponse: Codable {
    var code: Int
    var count: Int
    var data: signupResponse
}

struct UserResponse: Codable {
    var code: Int
    var count: Int
    var data: User
}
