//
//  Music.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/19.
//

import Foundation
import SwiftyJSON


struct Music: Codable, Equatable  {
    var id: String
    var playUrl: String
    var type: String
    var recommend: Int
    var atime: TimeInterval
    var author: String
    var animeInfo: AnimeInfo
    
    init(id: String, playUrl: String, type: String, recommend: Int, atime: TimeInterval, author: String, animeInfo: AnimeInfo) {
        self.id = id
        self.playUrl = playUrl
        self.type = type
        self.recommend = recommend
        self.atime = atime
        self.author = author
        self.animeInfo = animeInfo
    }
    
    init(json: JSON) {
        id = json["id"].stringValue
        playUrl = json["play_url"].stringValue
        type = json["type"].stringValue
        recommend = json["recommend"].intValue
        atime = json["atime"].doubleValue
        author = json["author"].stringValue
        animeInfo = AnimeInfo(json: json["anime_info"])
    }

    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
            let playUrl = dictionary["play_url"] as? String,
            let type = dictionary["type"] as? String,
            let recommend = dictionary["recommend"] as? Int,
            let atime = dictionary["atime"] as? TimeInterval,
            let author = dictionary["author"] as? String,
              let animeInfoDict = dictionary["anime_info"] as? [String: Any], let animeInfo = AnimeInfo(dictionary: animeInfoDict) else {
            return nil
        }

        
        self.init(id: id, playUrl: playUrl, type: type, recommend: recommend, atime: atime, author: author, animeInfo: animeInfo)
    }
    
    init() {
        self = Music(json: JSON())
    }

    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "play_url": playUrl,
            "type": type,
            "recommend": recommend,
            "atime": atime,
            "author": author,
            "anime_info": animeInfo,
        ]
    }

    static func == (lhs: Music, rhs: Music) -> Bool {
        return lhs.id == rhs.id &&
            lhs.playUrl == rhs.playUrl &&
            lhs.type == rhs.type &&
            lhs.recommend == rhs.recommend &&
            lhs.atime == rhs.atime &&
            lhs.author == rhs.author &&
            lhs.animeInfo == rhs.animeInfo
    }
}



struct MusicData: Codable, Equatable  {
    var id: String
    var playUrl: URL?
    var type: String
    var recommend: Int
    var atime: TimeInterval
    var author: String
    var animeInfoData: AnimeInfoData
    
    init(id: String, playUrl: URL?, type: String, recommend: Int, atime: TimeInterval, author: String, animeInfoData: AnimeInfoData) {
        self.id = id
        self.playUrl = playUrl
        self.type = type
        self.recommend = recommend
        self.atime = atime
        self.author = author
        self.animeInfoData = animeInfoData
    }

    init?(dictionary: [String: Any], from playUrl: String) {
        guard let id = dictionary["id"] as? String,
              let playUrl = dictionary[playUrl] as? URL,
            let type = dictionary["type"] as? String,
            let recommend = dictionary["recommend"] as? Int,
            let atime = dictionary["atime"] as? TimeInterval,
            let author = dictionary["author"] as? String,
              let animeInfoDict = dictionary["anime_info_Data"] as? [String: Any], let animeInfoData = AnimeInfoData(dictionary: animeInfoDict) else {
            return nil
        }

        
        self.init(id: id, playUrl: playUrl, type: type, recommend: recommend, atime: atime, author: author, animeInfoData: animeInfoData)
    }

    func toDictionary(playUrl: String) -> [String: Any] {
        return [
            "id": id,
            playUrl: playUrl,
            "type": type,
            "recommend": recommend,
            "atime": atime,
            "author": author,
            "anime_info_Data": animeInfoData,
        ]
    }

    static func == (lhs: MusicData, rhs: MusicData) -> Bool {
        return lhs.id == rhs.id &&
            lhs.playUrl == rhs.playUrl &&
            lhs.type == rhs.type &&
            lhs.recommend == rhs.recommend &&
            lhs.atime == rhs.atime &&
            lhs.author == rhs.author &&
            lhs.animeInfoData == rhs.animeInfoData
    }
}
