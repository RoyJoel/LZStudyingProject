//
//  LZMusicRequest.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/19.
//

import Foundation

class LZMusicRequest {
    static func getAll(completionHandler: @escaping ([Music]?, Error?) -> Void) {
        LZNetWork.get("/music/getAll") { json, error in
            guard let json = json else {
                completionHandler(nil, error)
                return
            }
            completionHandler(json.arrayValue.compactMap { Music(json: $0) }, nil)
        }
    }
    
    static func getMyMusic(completionHandler: @escaping ([Music]?, Error?) -> Void) {
        LZNetWork.post("/music/getMyMusic", dataParameters: ["id": LZUser.shared.user.id]) { json, error in
            guard let json = json else {
                completionHandler(nil, error)
                return
            }
            completionHandler(json.arrayValue.compactMap { Music(json: $0) }, nil)
        }
    }
    
    static func likeThisSong(musicId: String, completionHandler: @escaping (Bool) -> Void) {
        LZNetWork.post("/music/like", dataParameters: ["player_id": LZUser.shared.user.id, "music_id": musicId]) { json, error in
            guard let json = json else {
                completionHandler(false)
                return
            }
            guard error == nil else {
                completionHandler(false)
                return
            }
            completionHandler(json.boolValue)
        }
    }
    static func dislikeThisSong(musicId: String, completionHandler: @escaping (Bool) -> Void) {
        LZNetWork.post("/music/dislike", dataParameters: ["player_id": LZUser.shared.user.id, "music_id": musicId]) { json, error in
            guard let json = json else {
                completionHandler(false)
                return
            }
            guard error == nil else {
                completionHandler(false)
                return
            }
            completionHandler(json.boolValue)
        }
    }
}
