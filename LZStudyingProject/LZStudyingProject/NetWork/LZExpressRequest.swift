//
//  LZExpressRequest.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/28.
//

import CommonCrypto
import Foundation
import SwiftyJSON

struct ExpressRequestBody: Codable {
    let requestData: JSON
    let eBusinessID: String
    let dataType: String
    let dataSign: String
    let requestType: String

    private enum CodingKeys: String, CodingKey {
        case requestData = "RequestData"
        case eBusinessID = "EBusinessID"
        case dataType = "DataType"
        case dataSign = "DataSign"
        case requestType = "RequestType"
    }
}

class LZExpressRequest {
//    static func encryptAndEncodeRequestBody(requestBody: String, apiKey: String) -> String? {
//        let combinedString = requestBody + apiKey
//
//        // 将字符串转换为 UTF8 编码的字节数组
//        guard let data = combinedString.data(using: .utf8) else {
//            return nil
//        }
//
//        // 创建一个长度为 16 的缓冲区用于存储 MD5 结果
//        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
//
//        // 执行 MD5 加密操作
//        data.withUnsafeBytes { buffer in
//            _ = CC_MD5(buffer.baseAddress, CC_LONG(buffer.count), &digest)
//        }
//
//        // 将 MD5 结果转换为字符串形式
//        let md5String = digest.map { String(format: "%02x", $0) }.joined()
//
//        // 对 MD5 字符串进行 Base64 编码
//        guard let base64Data = md5String.data(using: .utf8) else {
//            return nil
//        }
//
//        let base64EncodedString = base64Data.base64EncodedString(options: [])
//
//        // 进行 URL 编码
//        guard let urlEncodedString = base64EncodedString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
//            return nil
//        }
//
//        return urlEncodedString
//    }

//    static func tapToOrder(completionHandler _: @escaping (String) -> Void) {
//        let requestBody = "Your Request Body"
//        let apiKey = "Your API Key"
//
//        if let encodedString = encryptAndEncodeRequestBody(requestBody: requestBody, apiKey: apiKey) {
//            print(encodedString)
//        }
//    }

//    let dic = [
//        "RequestData": ["ShipperCode": "STO","LogisticCode": "773222319107506"],
//        "DataType": "2",
//        "EBusinessID": "1800614",
//        "DataSign": "%7b%22ShipperCode%22%3a+%22STO%22%2c%22LogisticCode%22%3a+%22773222319107506%22%7d",
//        "RequestType": "1002",
//    ] as [String: Any]
//    AF.request(URL(string: "https://api.kdniao.com/Ebusiness/EbusinessOrderHandle.aspx")!, method: .post, parameters: dic, encoding: URLEncoding.default).response { response in
//        guard let jsonData = response.data else {
//            return
//        }
//        let json = try? JSON(data: jsonData)
//        print(json)
//    }

    func encryptData(requestData: [String: Any], apiKey: String) -> String? {
        do {
            // 将请求体转换为 JSON 数据
            let jsonData = try JSONSerialization.data(withJSONObject: requestData, options: [])

            // 将 JSON 数据转换为字符串
            if let requestBody = String(data: jsonData, encoding: .utf8) {
                // 将请求体和 API 密钥拼接
                let plaintext = requestBody + apiKey

                // 计算 MD5 散列值
                if let md5Data = plaintext.data(using: .utf8)?.md5 {
                    print(md5Data)
                    // 进行 Base64 编码
                    let base64EncodedData = md5Data.base64EncodedData()

                    print(base64EncodedData)
                    // 进行 URL 编码
                    if let urlEncodedString = base64EncodedData.urlEncodedString {
                        print(urlEncodedString)
                        return urlEncodedString
                    }
                }
            }
        } catch {
            print("JSON serialization error: \(error)")
        }

        return nil
    }
}
