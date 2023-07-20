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
    
    static let shared = LZUser()
        
    private init() {
        // 初始化代码
    }
    // 未登录时为默认信息
    lazy var user: User = {
        let user = User()
        return user
    }()

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
    
    static func searchPlayer(loginName: String, completionHandler: @escaping (Bool) -> Void) {
        let para = [
            "loginName": loginName,
        ]
        LZNetWork.post("/player/search", dataParameters: para) { json, error in
            guard let json = json else {
                completionHandler(false)
                return
            }
            completionHandler(json.boolValue)
        }
    }
}
