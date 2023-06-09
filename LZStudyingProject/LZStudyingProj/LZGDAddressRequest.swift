//
//  LZGDAddressRequest.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/25.
//

import Alamofire
import Foundation
import SwiftyJSON

class LZGDAddressRequest {
    static func requestGDAddress(completionHandler: @escaping ([District]?) -> Void) {
        let para = ["keywords": "中国", "subdistrict": "3", "key": "114a6d4a6b7f393fb5faf5d5021d9264"] as [String: Any]
        AF.request("https://restapi.amap.com/v3/config/district", parameters: para).response { response in
            guard let jsonData = response.data else {
                completionHandler(nil)
                return
            }
            guard let json = try? JSON(data: jsonData) else {
                completionHandler(nil)
                return
            }
            let country = District(json: json["districts"].arrayValue[0])
            completionHandler(country.districts)
        }
    }
}
