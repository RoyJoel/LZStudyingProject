//
//  LZMusicRequest.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/19.
//

import Foundation

class LZMusicRequest {
    static func getAll(completionHandler: @escaping ([Music]) -> Void) {
        LZNetWork.get("/music/getAll") { json, _ in
            guard let json = json else {
                return
            }
            completionHandler(json.arrayValue.compactMap { Music(json: $0) })
        }
    }
}
