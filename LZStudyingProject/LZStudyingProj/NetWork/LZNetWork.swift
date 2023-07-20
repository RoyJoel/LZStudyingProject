//
//  LZNetWork.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/28.
//

import Alamofire
import Foundation
import SwiftyJSON

class LZNetWork {
    static let LZURL = "http://localhost:8080"

    static func get(_ parameters: String, headers: HTTPHeaders? = nil, completionHandler: @escaping (JSON?, Error?) -> Void) {
        AF.request(URL(string: LZURL + parameters)!, headers: headers).response { response in
            guard response.response?.statusCode != 401 else {
                completionHandler(nil, LZNetWorkError.AuthError("认证失败"))
                return
            }
            guard response.response?.statusCode == 200 else {
                completionHandler(nil, LZNetWorkError.NetError("网络异常"))
                return
            }
            guard let jsonData = response.data else {
                completionHandler(nil, nil)
                return
            }
            
            let json = try? JSON(data: jsonData)
            completionHandler(json?["data"], nil)
        }
    }

    static func post<T: Decodable>(_ URLParameters: String, dataParameters: Encodable, responseBindingType: T.Type, completionHandler: @escaping (T?, Error?) -> Void) {
        guard let json = try? JSONEncoder().encode(dataParameters) else {
            return // 序列化失败，处理错误
        }

        guard let dictionary = try? JSONSerialization.jsonObject(with: json, options: []) as? [String: Any] else {
            return // 转换失败，处理错误
        }

        AF.request(URL(string: LZURL + URLParameters)!, method: .post, parameters: dictionary, encoding: JSONEncoding.default).responseDecodable(of: responseBindingType.self) { response in
            guard response.response?.statusCode == 200 else {
                completionHandler(nil, LZNetWorkError.NetError("网络异常"))
                return
            }
            
            switch response.result {
            case let .success(T):
                // 成功解码，处理 Response 对象
                completionHandler(T, nil)
            case .failure:
                // 解码失败，处理错误
                completionHandler(nil, LZNetWorkError.SerializationError("序列化失败"))
            }
        }
    }

    static func post(_ URLParameters: String, dataParameters: Encodable, completionHandler: @escaping (JSON?, Error?) -> Void) {
        guard let json = try? JSONEncoder().encode(dataParameters) else {
            return // 序列化失败，处理错误
        }

        guard let dictionary = try? JSONSerialization.jsonObject(with: json, options: []) as? [String: Any] else {
            return // 转换失败，处理错误
        }

        AF.request(URL(string: LZURL + URLParameters)!, method: .post, parameters: dictionary, encoding: JSONEncoding.default).response { response in
            guard response.response?.statusCode == 200 else {
                completionHandler(nil, LZNetWorkError.NetError("网络异常"))
                return
            }
            guard let jsonData = response.data else {
                completionHandler(nil, LZNetWorkError.SerializationError("序列化失败"))
                return
            }
            
            let json = try? JSON(data: jsonData)
            completionHandler(json?["data"], nil)
        }
    }

    static func post<T: Decodable>(_ URLParameters: String, dataParameters: Parameters?, responseBindingType: T.Type, completionHandler: @escaping (T?, Error?) -> Void) {
        AF.request(URL(string: LZURL + URLParameters)!, method: .post, parameters: dataParameters, encoding: JSONEncoding.default).responseDecodable(of: responseBindingType.self) { response in
            guard response.response?.statusCode == 200 else {
                completionHandler(nil, LZNetWorkError.NetError("网络异常"))
                return
            }
            
            switch response.result {
            case let .success(T):
                // 成功解码，处理 Response 对象
                completionHandler(T, nil)
            case .failure:
                // 解码失败，处理错误
                completionHandler(nil, LZNetWorkError.SerializationError("序列化失败"))
            }
        }
    }

    static func post(_ URLParameters: String, dataParameters: Parameters?, completionHandler: @escaping (JSON?, Error?) -> Void) {
        AF.request(URL(string: LZURL + URLParameters)!, method: .post, parameters: dataParameters, encoding: JSONEncoding.default).response { response in
            guard response.response?.statusCode == 200 else {
                completionHandler(nil, LZNetWorkError.NetError("网络异常"))
                return
            }
            guard let jsonData = response.data else {
                completionHandler(nil, LZNetWorkError.SerializationError("序列化失败"))
                return
            }
            
            let json = try? JSON(data: jsonData)
            completionHandler(json?["data"], nil)
        }
    }

    static func postWithURLEncoded(_ URLParameters: String, dataParameters: Parameters?, completionHandler: @escaping (JSON?, Error?) -> Void) {
        AF.request(URL(string: LZURL + URLParameters)!, method: .post, parameters: dataParameters, encoding: URLEncoding.default).response { response in
            guard response.response?.statusCode == 200 else {
                completionHandler(nil, LZNetWorkError.NetError("网络异常"))
                return
            }
            guard let jsonData = response.data else {
                completionHandler(nil, LZNetWorkError.SerializationError("序列化失败"))
                return
            }
            
            let json = try? JSON(data: jsonData)
            completionHandler(json?["data"], nil)
        }
    }
}

enum LZNetWorkError: Error {
    case AuthError(String)
    case NetError(String)
    case SerializationError(String)
}