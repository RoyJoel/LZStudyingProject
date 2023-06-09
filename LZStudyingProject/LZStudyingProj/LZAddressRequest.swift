//
//  LZAddressRequest.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/14.
//

import Foundation

class LZAddressRequest {
    static func addAddress(address: AddressRequest, completionHandler: @escaping (Address) -> Void) {
        LZNetWork.post("/address/add", dataParameters: address) { json in
            guard let json = json else {
                return
            }
            let address = Address(json: json)
            LZUser.user.addresss.append(address.id)
            if address.isDefault {
                LZUser.user.defaultAddress = address
            }
            completionHandler(address)
        }
    }

    static func UpdateAddress(address: AddressRequest, completionHandler: @escaping (Address) -> Void) {
        LZNetWork.post("/address/update", dataParameters: address) { json in
            guard let json = json else {
                return
            }
            if address.isDefault {
                LZUser.user.defaultAddress = Address(json: json)
            }
            completionHandler(Address(json: json))
        }
    }

    static func deleteAddress(id: Int, completionHandler: @escaping (Bool) -> Void) {
        LZNetWork.post("/address/delete", dataParameters: ["id": id]) { json in
            guard let json = json else {
                return
            }
            completionHandler(json.boolValue)
        }
    }

    static func getAddressInfos(ids: [Int], completionHandler: @escaping ([Address]) -> Void) {
        LZNetWork.post("/address/getInfos", dataParameters: ["ids": ids]) { json in
            guard let json = json else {
                return
            }
            completionHandler(json.arrayValue.map { Address(json: $0) })
        }
    }
}
