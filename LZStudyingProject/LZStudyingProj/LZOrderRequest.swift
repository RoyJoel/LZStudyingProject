//
//  LZOrderRequest.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/16.
//

import Foundation

class LZOrderRequest {
    static func getInfos(id: Int, completionHandler: @escaping ([Order]) -> Void) {
        LZNetWork.post("/order/getInfos", dataParameters: ["id": id]) { json in
            guard let json = json else {
                return
            }
            completionHandler(json.arrayValue.map { Order(json: $0) })
        }
    }

    static func addOrder(order: OrderRequest, completionHandler: @escaping (Int) -> Void) {
        LZNetWork.post("/order/add", dataParameters: order) { json in
            guard let json = json else {
                return
            }
            LZUser.user.allOrders.append(json.intValue)
            completionHandler(json.intValue)
        }
    }

    static func updateOrder(order: OrderRequest, completionHandler: @escaping (Int) -> Void) {
        LZNetWork.post("/order/update", dataParameters: order) { json in
            guard let json = json else {
                return
            }
            LZUser.user.allOrders.append(json.intValue)
            completionHandler(json.intValue)
        }
    }

    static func deleteOrder(id: Int, completionHandler: @escaping (Int) -> Void) {
        LZNetWork.post("/order/update", dataParameters: ["id": id]) { json in
            guard let json = json else {
                return
            }
            LZUser.user.allOrders.removeAll(where: { $0 == id })
            completionHandler(json.intValue)
        }
    }
}
