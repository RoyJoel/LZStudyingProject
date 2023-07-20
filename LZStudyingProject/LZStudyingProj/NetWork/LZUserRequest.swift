//
//  LZUserRequest.swift
//  LZStudyingProj
//
//  Created by Jason Zhang on 2023/7/7.
//

import Foundation
import CryptoKit

class LZUserRequest {
    static func signIn(completionHandler: @escaping (User?, Error?) -> Void) {
        // 将要加密的字符串连接在一起
        let password = LZUser.shared.user.password

        // 计算 SHA256 哈希值
        if let data = password.data(using: .utf8) {
            let hash = SHA256.hash(data: data)
            let hashString = hash.map { String(format: "%02x", $0) }.joined()

            let para = [
                "loginName": LZUser.shared.user.loginName,
                "password": hashString,
            ]
            LZNetWork.post("/user/signIn", dataParameters: para) { json, error in
                guard let json = json else {
                    completionHandler(nil, error)
                    return
                }
                completionHandler(User(json: json), nil)
            }
        }
    }

    static func signUp(completionHandler: @escaping (String?, Error?) -> Void) {
        LZNetWork.post("/user/signUp", dataParameters: LZUser.shared.user) { json, error in
            guard let json = json else {
                completionHandler(nil, error)
                return
            }
            LZUser.shared.user = User(json: json["data"]["user"])
            completionHandler(LZUser.shared.user.token, nil)
        }
    }

    static func resetPassword(completionHandler: @escaping (Bool) -> Void) {
        let para = [
            "loginName": LZUser.shared.user.loginName,
            "password": LZUser.shared.user.password,
        ]
        LZNetWork.post("/user/resetPassword", dataParameters: para) { json, error in
            guard let json = json else {
                completionHandler(false)
                return
            }
            completionHandler(json.boolValue)
        }
    }

    static func updateInfo(completionHandler: @escaping (User?, Error?) -> Void) {
        LZNetWork.post("/user/update", dataParameters: LZUser.shared.user) { json, error in
            guard let json = json else {
                completionHandler(nil, error)
                return
            }
            LZUser.shared.user = User(json: json)
            completionHandler(LZUser.shared.user, nil)
        }
    }

}
