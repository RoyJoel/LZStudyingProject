//
//  LZCommodityRequest.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/15.
//

import Foundation

class LZCommodityRequest {
    static func getAll(completionHandler: @escaping ([Commodity]) -> Void) {
        LZNetWork.get("/commodity/getAll") { json, _ in
            guard let json = json else {
                return
            }
            LZUser.commodities = json.arrayValue.compactMap { Commodity(json: $0) }
            completionHandler(json.arrayValue.compactMap { Commodity(json: $0) })
        }
    }
}
