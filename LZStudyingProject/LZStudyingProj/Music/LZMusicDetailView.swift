//
//  LZMusicDetailView.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/25.
//

import Foundation
import UIKit
import TMComponent
import SDWebImage
import AVFoundation
import Alamofire
import MediaPlayer

class LZMusicDetailView: TMScalableView {
    lazy var iconView: TMScalableImageView = {
        let imageView = TMScalableImageView()
        return imageView
    }()
    
    lazy var titleLabel: TMScalableLabel = {
        let label = TMScalableLabel()
        return label
    }()
    
    lazy var controlView: LZMusicControllerView = {
        let view = LZMusicControllerView()
        return view
    }()
    
    lazy var authorView: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var titleViewBackgroundView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var progressView: UIProgressView = {
        let view = UIProgressView()
        return view
    }()
    
    lazy var likedBtn: TMBasicButton = {
        let btn = TMBasicButton()
        return btn
    }()
    
    lazy var addBtn: TMBasicButton = {
        let btn = TMBasicButton()
        return btn
    }()
    
    lazy var playModeBtn: TMBasicButton = {
        let btn = TMBasicButton()
        return btn
    }()
    
    lazy var playListBtn: TMBasicButton = {
        let btn = TMBasicButton()
        return btn
    }()
    
    lazy var playListView: TMTableView = {
        let view = TMTableView()
        return view
    }()
    
    lazy var blurBackgroundView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        return view
    }()
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var player: AVPlayer = {
        let player = AVPlayer()
        return player
    }()
    
    lazy var timer: Timer = {
        let timer = Timer()
        return timer
    }()
    
    var playList: [Music] = [] {
        willSet {
            self.playList = newValue
            currentMusicIndex = 0
            playMusic()
        }
    }
    var currentMusicIndex: Int = 0 {
        willSet {
            self.currentMusicIndex = newValue
            setupEvent(music: playList[newValue])
        }
    }
    
    var isLiked: Bool = false {
        willSet {
            if newValue {
                LZMusicRequest.likeThisSong(musicId: music?.id ?? "") { _ in
                    let likedBtnConfig = TMButtonConfig(image: UIImage(systemName: "heart.fill")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), action: #selector(self.likeThisSong), actionTarget: self)
                    self.likedBtn.setupEvent(config: likedBtnConfig)
                    guard !LZUser.shared.user.allLikedMusic.contains(where: { $0 == self.music?.id }) else {
                        return
                    }
                    LZUser.shared.user.allLikedMusic.append(self.music?.id ?? "")
                }
            }else {
                LZMusicRequest.dislikeThisSong(musicId: music?.id ?? "") { _ in
                    let likedBtnConfig = TMButtonConfig(image: UIImage(systemName: "heart")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), action: #selector(self.likeThisSong), actionTarget: self)
                    self.likedBtn.setupEvent(config: likedBtnConfig)
                    LZUser.shared.user.allLikedMusic.removeAll(where: { $0 == self.music?.id })
                }
            }
        }
    }
    
    var nowPlayingInfo = [String: Any]()
    
    var playMode: PlayMode = .ListRepeating {
        willSet {
            switch newValue {
            case .ListRepeating:
                let playModeBtnConfig = TMButtonConfig(image: UIImage(systemName: "repeat")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), action: #selector(changePlayMode), actionTarget: self)
                playModeBtn.setupEvent(config: playModeBtnConfig)
            case .SingleRepeating:
                let playModeBtnConfig = TMButtonConfig(image: UIImage(systemName: "repeat.1")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), action: #selector(changePlayMode), actionTarget: self)
                playModeBtn.setupEvent(config: playModeBtnConfig)
            case .Random:
                let playModeBtnConfig = TMButtonConfig(image: UIImage(systemName: "shuffle")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), action: #selector(changePlayMode), actionTarget: self)
                playModeBtn.setupEvent(config: playModeBtnConfig)
            }
            UserDefaults.standard.set(newValue.rawValue, forKey: LZUDKeys.PlayMode.rawValue)
        }
    }
    
    var music: Music?
    
    func setupUI() {
        backgroundColor = UIColor(named: "ComponentBackground")
        setCorner(radii: 15)
        
        addSubview(backgroundImageView)
        addSubview(blurBackgroundView)
        addSubview(controlView)
        addSubview(iconView)
        addSubview(titleLabel)
        insertSubview(titleViewBackgroundView, belowSubview: titleLabel)
        titleViewBackgroundView.addSubview(authorView)
        addSubview(progressView)
        addSubview(likedBtn)
        addSubview(addBtn)
        addSubview(playModeBtn)
        addSubview(playListBtn)
        insertSubview(playListView, belowSubview: playListBtn)
        
        backgroundImageView.frame = CGRect(x: 0, y: 0, width: UIStandard.shared.screenWidth, height: UIStandard.shared.screenHeight)
        backgroundImageView.image = UIImage()
        backgroundImageView.contentMode = .scaleAspectFill
        blurBackgroundView.effect = UIBlurEffect(style: .light)
        blurBackgroundView.frame = CGRect(x: 0, y: 0, width: UIStandard.shared.screenWidth, height: UIStandard.shared.screenHeight)
        iconView.frame = CGRect(x: 12, y: 6, width: bounds.height - 12, height: bounds.height - 12)
        
        controlView.frame = CGRect(x: bounds.width - 120, y: 6, width: 108, height: bounds.height - 12)
        
        titleLabel.frame = CGRect(x: bounds.height + 6, y: 0, width: bounds.width - bounds.height - 6 - 120, height: bounds.height)
        
        playListView.frame = CGRect(x: UIStandard.shared.screenWidth - 104, y: 762, width: 68, height: 68)
        
        titleViewBackgroundView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(466)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(92)
        }
        
        authorView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-12)
            make.height.equalTo(25)
            make.left.equalToSuperview().offset(12)
        }
        
        likedBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(572)
            make.left.equalToSuperview().offset(36)
            make.width.height.equalTo(68)
        }
        
        addBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(572)
            make.right.equalToSuperview().offset(-36)
            make.width.height.equalTo(68)
        }
        
        playModeBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(762)
            make.left.equalToSuperview().offset(36)
            make.width.height.equalTo(68)
        }
        
        playListBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(762)
            make.right.equalToSuperview().offset(-36)
            make.width.height.equalTo(68)
        }
        
        progressView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
            make.width.equalToSuperview().offset(-96)
            make.top.equalToSuperview().offset(664)
        }
        
        titleViewBackgroundView.setCorner(radii: 10)
        titleViewBackgroundView.alpha = 0.6
        
        likedBtn.alpha = 0.6
        addBtn.alpha = 0.6
        playListBtn.alpha = 0.6
        playModeBtn.alpha = 0.6
        
        let likedBtnConfig = TMButtonConfig(image: UIImage(systemName: "heart")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal),action: #selector(likeThisSong), actionTarget: self)
        likedBtn.setupEvent(config: likedBtnConfig)
        
        let addBtnConfig = TMButtonConfig(image: UIImage(systemName: "plus")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), action: #selector(downMusic), actionTarget: self)
        addBtn.setupEvent(config: addBtnConfig)
        
        let playMode = UserDefaults.standard.integer(forKey: LZUDKeys.PlayMode.rawValue)
        switch playMode {
        case 1:
            let playModeBtnConfig = TMButtonConfig(image: UIImage(systemName: "repeat.1")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), action: #selector(changePlayMode), actionTarget: self)
            playModeBtn.setupEvent(config: playModeBtnConfig)
        case 2:
            let playModeBtnConfig = TMButtonConfig(image: UIImage(systemName: "shuffle")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), action: #selector(changePlayMode), actionTarget: self)
            playModeBtn.setupEvent(config: playModeBtnConfig)
        case 3:
            let playModeBtnConfig = TMButtonConfig(image: UIImage(systemName: "list.bullet.indent")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), action: #selector(changePlayMode), actionTarget: self)
            playModeBtn.setupEvent(config: playModeBtnConfig)
        default:
            let playModeBtnConfig = TMButtonConfig(image: UIImage(systemName: "repeat")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), action: #selector(changePlayMode), actionTarget: self)
            playModeBtn.setupEvent(config: playModeBtnConfig)
        }
        let playListBtnConfig = TMButtonConfig(image: UIImage(systemName: "list.bullet")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), action: #selector(showPlayList), actionTarget: self)
        playListBtn.setupEvent(config: playListBtnConfig)
        
        controlView.setupUI()
        controlView.completionHandler = { res in
            if res == true {
                self.player.play()
                self.setTimer(true)
            }else {
                self.player.pause()
                self.setTimer(false)
            }
        }
        
        controlView.lastBtn.addTarget(self, action: #selector(stepToLast), for: .touchDown)
        controlView.nextBtn.addTarget(self, action: #selector(stepToNext), for: .touchDown)
        playListView.setup(playListView.bounds, playListView.layer.position, CGRect(x: 0, y: 0, width: UIStandard.shared.screenWidth / 2, height: 400), CGPoint(x: playListView.layer.position.x - (UIStandard.shared.screenWidth / 2 - 68) / 2, y: playListView.layer.position.y - 166), 0.3)
        playListView.register(LZMusicCell.self, forCellReuseIdentifier: "PlayListCell")
        playListView.dataSource = self
        playListView.delegate = self
        playListView.setCorner(radii: 15)
        
        iconView.setCorner(radii: 10)
        iconView.contentMode = .scaleAspectFill
        iconView.clipsToBounds = true
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.tintColor = UIColor(named: "ContentBackground")
        titleViewBackgroundView.backgroundColor = UIColor(named: "BackgroundGray")
        authorView.textColor = UIColor(named: "SubTitleTintColor")
        
        progressView.setCorner(radii: 10)
        progressView.progressTintColor = .gray
        
        progressView.addPanGesture(self, #selector(editProgress))
        
        iconView.setup(originalBounds: iconView.bounds, originalPoint: iconView.layer.position, newBounds: CGRect(x: 0, y: 0, width: 232, height: 232), newPoint: CGPoint(x: UIStandard.shared.screenWidth / 2, y: 248), duration: 0.3)
        titleLabel.setup(originalBounds: titleLabel.bounds, originalPoint: titleLabel.layer.position, newBounds: CGRect(x: 0, y: 0, width: UIStandard.shared.screenWidth - 72, height: 25), newPoint: CGPoint(x: UIStandard.shared.screenWidth / 2, y: 498), duration: 0.3)
        controlView.setup(originalBounds: controlView.bounds, originalPoint: controlView.layer.position, newBounds: CGRect(x: 0, y: 0, width: UIStandard.shared.screenWidth / 2, height: 68), newPoint: CGPoint(x: UIStandard.shared.screenWidth / 2, y: 734), duration: 0.3)
        
        
        
        backgroundImageView.isHidden = true
        titleViewBackgroundView.isHidden = true
        authorView.isHidden = true
        likedBtn.isHidden = true
        addBtn.isHidden = true
        playModeBtn.isHidden = true
        playListBtn.isHidden = true
        progressView.isHidden = true
        playListView.isHidden = true
        
        setupPlayer()
        
        setupCommandCenter()
    }
    
    func setupPlayer() {
        player.volume = 1.0
        player.actionAtItemEnd = .none
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .default, options: .allowAirPlay)
        try? session.setActive(true)
    }
    
    func setupEvent(music: Music) {
        self.music = music
        controlView.isPlaying = false
        if let musicInfo = UserDefaults.standard.data(forKey: music.id) {
            do {
                let localMusic = try PropertyListDecoder().decode(MusicData.self, from: musicInfo)
                guard let playUrl = localMusic.playUrl, let bg = localMusic.animeInfoData.bg[music.animeInfo.bg], let logo = localMusic.animeInfoData.logo[music.animeInfo.logo] else {
                    playTemp(music: music)
                    saveSongToCache(music: music)
                    return
                }
                let playItem = AVPlayerItem(url: playUrl)
                player = AVPlayer(playerItem: playItem)
                iconView.image = UIImage(data: logo)
                self.backgroundImageView.image = UIImage(data: bg)
                self.progressView.progressTintColor = UIColor(patternImage: UIImage(data: bg) ?? UIImage() )
                titleLabel.text = localMusic.animeInfoData.title
                authorView.text = localMusic.author
                
            }catch {
                print("下载音乐文件时发生错误：\(error)")
            }
        }else {
            if UserDefaults.standard.bool(forKey: LZUDKeys.SongCache.rawValue) {
                playTemp(music: music)
                saveSongToCache(music: music)
            }else {
                playTemp(music: music)
            }
        }
        isLiked = LZUser.shared.user.allLikedMusic.contains { $0 == music.id }
        self.playListView.reloadData()
    }
    
    func playTemp(music: Music) {
        guard let playUrl = URL(string: music.playUrl) else {
            return
        }
        player = AVPlayer(url: playUrl)
        titleLabel.text = music.animeInfo.title
        authorView.text = music.author
        SDWebImageManager.shared.loadImage(with: URL(string: music.animeInfo.logo)) { _, _, _ in
        } completed: { image, _, _, _, _, _ in
            self.iconView.image = image
        }
        SDWebImageManager.shared.loadImage(with: URL(string: music.animeInfo.bg)) { _, _, _ in
        } completed: { image, _, _, _, _, _ in
            self.backgroundImageView.image =  image
            self.progressView.progressTintColor = UIColor(patternImage: image ?? UIImage() )
        }
        
    }
    
    func saveSongToCache(music: Music) {
        var playPath = URL(string: "")
        var logo = Data()
        var bg = Data()
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        guard let playUrl = URL(string: music.playUrl) else {
            return
        }
        AF.download(playUrl).responseData { response in
            switch response.result {
            case .success(let data):
                guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
                    return
                }
                let musicURL = cacheDirectory.appendingPathComponent("\(music.id).mp3")
                do {
                    try data.write(to: musicURL)
                    playPath = musicURL
                    dispatchGroup.leave()
                } catch {
                    print("音乐文件写入失败: \(error)")
                    dispatchGroup.leave()
                }
            case .failure(let error):
                print("下载音乐文件时发生错误：\(error)")
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        guard let bgUrl = URL(string: music.animeInfo.bg) else {
            return
        }
        AF.download(bgUrl).responseData { response in
            switch response.result {
            case .success(let data):
                    bg = data
                dispatchGroup.leave()
            case .failure(let error):
                print("下载音乐文件时发生错误：\(error)")
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        guard let logoUrl = URL(string: music.animeInfo.logo) else {
            return
        }
        AF.download(logoUrl).responseData { response in
            switch response.result {
            case .success(let data):
                    logo = data
                dispatchGroup.leave()
            case .failure(let error):
                print("下载音乐文件时发生错误：\(error)")
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            // 所有任务完成后执行的操作
            let animeData = AnimeInfoData(id: music.animeInfo.id, bg: [music.animeInfo.bg: bg], year: music.animeInfo.year, month: music.animeInfo.month, title: music.animeInfo.title, atime: music.animeInfo.atime, desc: music.animeInfo.desc, logo: [music.animeInfo.logo: logo])
            let musicInfo = MusicData(id: music.id, playUrl: playPath , type: music.type, recommend: music.recommend, atime: music.atime, author: music.author, animeInfoData: animeData)
            
           let musicData = try? PropertyListEncoder().encode(musicInfo)
            UserDefaults.standard.set(musicData, forKey: music.id)
        }
    }
    
    func setPlayList(_ playList: [Music]) {
        self.playList = playList
    }
    
    func setupCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.addTarget { event in
            self.controlView.isPlaying = true
            return .success
        }
        
        commandCenter.pauseCommand.addTarget { event in
            self.controlView.isPlaying = false
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget { event in
            self.switchSong(isForward: true)
            return .success
        }
        commandCenter.previousTrackCommand.addTarget { event in
            self.switchSong(isForward: false)
            return .success
        }
        
        commandCenter.changePlaybackPositionCommand.isEnabled = true
        commandCenter.changePlaybackPositionCommand.addTarget { [weak self] event in
            guard let self = self else { return .commandFailed }
            
            if let positionEvent = event as? MPChangePlaybackPositionCommandEvent {
                let position = positionEvent.positionTime
                setTimer(false)
                // 计算拖动的进度时间
                let time = CMTime(seconds: position, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
                // 设置播放器的当前时间
                player.seek(to: time)
                
                // 更新播放进度显示
                let elapsedPlaybackTime = CMTimeGetSeconds(player.currentTime())
                
                nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedPlaybackTime
                nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = CMTimeGetSeconds(player.currentItem?.duration ?? .zero)
                MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
                
                print("目前进度 \(position) \(self.player.currentTime().seconds) \(self.player.currentItem?.duration.seconds ?? 0) \(Float(self.player.currentTime().seconds / (self.player.currentItem?.duration.seconds ?? 0)))")
                updateProgress()
                setTimer(true)
                return .success
            }
            return .commandFailed
        }
    }
    
    func setNowPlayingInfoCenter(title: String, author: String, logo: UIImage) {
        let artwork = MPMediaItemArtwork(boundsSize: logo.size) { _ in
            return logo
        }
        guard let playUrl = URL(string: music?.playUrl ?? "") else {
            return
        }
        let asset = AVAsset(url: playUrl)
        let playingItem = AVPlayerItem(asset: asset)
        let elapsedPlaybackTime = CMTimeGetSeconds(playingItem.currentTime())
        let playbackDuration = CMTimeGetSeconds(asset.duration)
        
        nowPlayingInfo[MPMediaItemPropertyTitle] = title
        nowPlayingInfo[MPMediaItemPropertyArtist] = author
        nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedPlaybackTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = playbackDuration
        // 添加其他需要的信息

        // 将媒体信息设置到 MPNowPlayingInfoCenter
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    func setTimer(_ isOn: Bool) {
        if isOn {
            self.timer = Timer(timeInterval: 0.1, target: self, selector: #selector(self.updateProgress), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timer, forMode: .default)
        }else {
            self.timer.invalidate()
        }
    }
    
    func setProgress(_ progress: Float) {
        progressView.setProgress(progress, animated: true)
    }
    
    @objc func showPlayList() {
        if playListView.toggle {
            playListView.scaleTo(playListView.toggle) {
                self.playListView.isHidden = true
            }
        }else {
            self.playListView.isHidden = false
            playListView.scaleTo(playListView.toggle)
        }
    }
    
    @objc func stepToNext() {
        switchSong(isForward: true)
    }
    
    @objc func stepToLast() {
        switchSong(isForward: false)
    }
    
    @objc func downMusic() {
        
    }
    
    @objc func editProgress(_ gesture: UIPanGestureRecognizer) {
        setTimer(false)
        let translation = gesture.translation(in: self)
        let horizontalMovement = translation.x
        let currentProgress = CGFloat(self.progressView.progress)
        if gesture.state == .changed {
            if horizontalMovement > 0 {
                var movementPresent = horizontalMovement / progressView.frame.size.width
                movementPresent += currentProgress
                progressView.setProgress(Float(movementPresent), animated: true)
                print(movementPresent)
            }else {
                var movementPresent = horizontalMovement / progressView.frame.size.width
                movementPresent += currentProgress
                progressView.setProgress(Float(movementPresent), animated: true)
                print(movementPresent)
            }
            gesture.setTranslation(CGPoint.zero, in: progressView)
        }
        if gesture.state == .ended {
            var movementPresent = horizontalMovement / progressView.frame.size.width
            movementPresent += currentProgress
            
            let playPosition = (self.player.currentItem?.duration.seconds ?? 0) * movementPresent
            player.seek(to: CMTime(seconds: playPosition, preferredTimescale: 1))
            
            if movementPresent == 1 {
                switchSong(isForward: true)
            }else {
                self.setProgress(Float(movementPresent))
            }
            setTimer(true)
        }
    }
    
    @objc func updateProgress() {
        guard self.player.currentItem?.duration.seconds != 0 else {
            return
        }
        let progress = Float(self.player.currentTime().seconds / (self.player.currentItem?.duration.seconds ?? 0))
        if progress == 1 {
            switchSong(isForward: true)
        }else {
            self.setProgress(progress)
        }
    }
    
    @objc func likeThisSong() {
        isLiked.toggle()
    }
    
    @objc func changePlayMode() {
        switch playMode {
        case .ListRepeating:
            self.playMode = .SingleRepeating
        case .SingleRepeating:
            self.playMode = .Random
        case .Random:
            self.playMode = .ListRepeating
        }
    }
    func playMusic() {
        controlView.isPlaying = true
        setNowPlayingInfoCenter(title: music?.animeInfo.title ?? "", author: music?.author ?? "", logo: iconView.image ?? UIImage())
    }
    func switchSong(isForward: Bool) {
        let PlayMode = UserDefaults.standard.integer(forKey: LZUDKeys.PlayMode.rawValue)
        switch PlayMode {
        case 1:
            setupEvent(music: playList[currentMusicIndex])
            playMusic()
        case 2:
            guard playList.count > 1 else {
                currentMusicIndex = 0
                return
            }
            playList.remove(at: currentMusicIndex)
            currentMusicIndex = Int(arc4random_uniform(UInt32(playList.count)))
            playMusic()
        default:
            if isForward {
                guard currentMusicIndex < playList.count - 1 else {
                    currentMusicIndex = 0
                    playMusic()
                    return
                }
                currentMusicIndex += 1
                playMusic()
            }else {
                guard currentMusicIndex > 0 else {
                    currentMusicIndex = playList.count - 1
                    playMusic()
                    return
                }
                currentMusicIndex -= 1
                playMusic()
            }
        }
    }
    
    override func scaleTo(completionHandler: (() -> Void)? = nil) {

        if toggle {
            super.scaleTo() {
                (completionHandler ?? {})()
                self.backgroundImageView.isHidden = true
            }
            titleViewBackgroundView.isHidden = true
            authorView.isHidden = true
            likedBtn.isHidden = true
            addBtn.isHidden = true
            playModeBtn.isHidden = true
            playListBtn.isHidden = true
            progressView.isHidden = true
            iconView.scaleTo()
            titleLabel.scaleTo()
            controlView.scaleTo()
        }else {
            backgroundImageView.isHidden = false
            super.scaleTo() {
                (completionHandler ?? {})()
                self.titleViewBackgroundView.isHidden = false
                self.authorView.isHidden = false
                self.likedBtn.isHidden = false
                self.addBtn.isHidden = false
                self.playModeBtn.isHidden = false
                self.playListBtn.isHidden = false
                self.progressView.isHidden = false
            }
            iconView.scaleTo()
            titleLabel.scaleTo()
            controlView.scaleTo()
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if !CGRectContainsPoint(playListView.frame, point) && playListView.toggle{
            playListView.scaleTo(playListView.toggle) {
                self.playListView.isHidden = true
            }
        }
        return super.hitTest(point, with: event)
    }
}

extension LZMusicDetailView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        playList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayListCell") as? LZMusicCell
        cell?.setupEvent(music: playList[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        68
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if URL(string: playList[indexPath.row].playUrl) != nil {
            let maxIndex = min(indexPath.row + 49, playList.count - 1)
            let playList = Array(playList[indexPath.row...maxIndex])
            NotificationCenter.default.post(name: Notification.Name(ToastNotification.PlayMusic.rawValue), object: nil, userInfo: ["PlayList": playList])
        }else {
            let toastView = UILabel()
            toastView.text = NSLocalizedString("音乐信息失效", comment: "")
            toastView.numberOfLines = 2
            toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
            toastView.backgroundColor = UIColor(named: "ComponentBackground")
            toastView.textAlignment = .center
            toastView.setCorner(radii: 15)
            showToast(toastView, point: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2))
        }
    }
}
