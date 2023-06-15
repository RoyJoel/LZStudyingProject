//
//  DataExtension.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/1.
//

import CommonCrypto
import Foundation

// 辅助扩展：Data 的 MD5 散列值计算
extension Data {
    var md5: Data {
        var digest = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        _ = digest.withUnsafeMutableBytes { digestBytes in
            self.withUnsafeBytes { messageBytes in
                CC_MD5(messageBytes.baseAddress, CC_LONG(self.count), digestBytes.bindMemory(to: UInt8.self).baseAddress)
            }
        }
        return digest
    }
}

// 辅助扩展：Data 的 URL 编码
extension Data {
    var urlEncodedString: String? {
        return String(data: self, encoding: .utf8)?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
}
