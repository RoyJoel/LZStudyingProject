//
//  MusicDetailView.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/25.
//

import Foundation
import UIKit
import TMComponent
import SDWebImage
import AVFoundation

class MusicDetailView: TMView {
    lazy var iconView: TMImageView = {
        let imageView = TMImageView()
        return imageView
    }()
    
    lazy var titleLabel: TMLabel = {
        let label = TMLabel()
        return label
    }()
    
    lazy var controlView: ControlView = {
        let view = ControlView()
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
    
    lazy var likedBtn: TMButton = {
        let btn = TMButton()
        return btn
    }()
    
    lazy var addBtn: TMButton = {
        let btn = TMButton()
        return btn
    }()
    
    lazy var playModeBtn: TMButton = {
        let btn = TMButton()
        return btn
    }()
    
    lazy var playListBtn: TMButton = {
        let btn = TMButton()
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
        }
    }
    var currentMusicIndex: Int = 0 {
        willSet {
            self.currentMusicIndex = newValue
            setupPlayerView(music: playList[newValue])
            playMusic()
        }
    }
    
    var isLiked: Bool = false {
        willSet {
            if newValue {
                likedBtn.setImage(UIImage(systemName: "heart.fill")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), for: .normal)
                guard LZUser.user.allLikedMusic.contains(where: { $0 == music?.id }) else {
                    return
                }
                LZUser.user.allLikedMusic.append(music?.id ?? "")
            }else {
                likedBtn.setImage(UIImage(systemName: "heart")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), for: .normal)
                LZUser.user.allLikedMusic.removeAll(where: { $0 == music?.id })
            }
        }
    }
    
    func setTimer(_ isOn: Bool) {
        if isOn {
            self.timer = Timer(timeInterval: 0.1, target: self, selector: #selector(self.updateProgress), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timer, forMode: .default)
        }else {
            self.timer.invalidate()
        }
    }
    
    var playMode: PlayMode = .ListRepeating {
        willSet {
            switch newValue {
            case .ListOrder:
                playModeBtn.setImage(UIImage(systemName: "list.bullet.indent")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), for: .normal)
            case .ListRepeating:
                playModeBtn.setImage(UIImage(systemName: "repeat")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), for: .normal)
            case .SingleRepeating:
                playModeBtn.setImage(UIImage(systemName: "repeat.1")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), for: .normal)
            case .Random:
                playModeBtn.setImage(UIImage(systemName: "shuffle")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), for: .normal)
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
        
        likedBtn.setImage(UIImage(systemName: "heart")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), for: .normal)
        
        addBtn.setImage(UIImage(systemName: "plus")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), for: .normal)
        
        let playMode = UserDefaults.standard.integer(forKey: LZUDKeys.PlayMode.rawValue)
        switch playMode {
        case 1:
            playModeBtn.setImage(UIImage(systemName: "repeat.1")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), for: .normal)
        case 2:
            playModeBtn.setImage(UIImage(systemName: "shuffle")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), for: .normal)
        case 3:
            playModeBtn.setImage(UIImage(systemName: "list.bullet.indent")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), for: .normal)
        default:
            playModeBtn.setImage(UIImage(systemName: "repeat")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), for: .normal)
        }
        playListBtn.setImage(UIImage(systemName: "list.bullet")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), for: .normal)
        
        controlView.setupUI()
        controlView.completionHandler = { res in
            if res == true {
                self.player.play()
            }else {
                self.player.pause()
            }
        }
        
        playListView.setup(playListView.bounds, playListView.layer.position, CGRect(x: 0, y: 0, width: UIStandard.shared.screenWidth / 2, height: 400), CGPoint(x: playListView.layer.position.x - (UIStandard.shared.screenWidth / 2 - 68) / 2, y: playListView.layer.position.y - 166), 0.3)
        playListView.register(LZMusicCell.self, forCellReuseIdentifier: "MusicCell")
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
        
        iconView.setup(iconView.bounds, iconView.layer.position, CGRect(x: 0, y: 0, width: 232, height: 232), CGPoint(x: UIStandard.shared.screenWidth / 2, y: 248), 0.3)
        titleLabel.setup(titleLabel.bounds, titleLabel.layer.position, CGRect(x: 0, y: 0, width: UIStandard.shared.screenWidth - 72, height: 25), CGPoint(x: UIStandard.shared.screenWidth / 2, y: 498), 0.3)
        controlView.setup(controlView.bounds, controlView.layer.position, CGRect(x: 0, y: 0, width: UIStandard.shared.screenWidth / 2, height: 68), CGPoint(x: UIStandard.shared.screenWidth / 2, y: 734), 0.3)
        
        
        likedBtn.addTapGesture(self, #selector(likeThisSong))
        playModeBtn.addTapGesture(self, #selector(changePlayMode))
        playListBtn.addTapGesture(self, #selector(showPlayList))
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
    }
    
    func setupPlayer() {
        player.volume = 1.0
        player.allowsExternalPlayback = true
        player.actionAtItemEnd = .none
    }
    
    func setupPlayerView(music: Music) {
        guard let playUrl = URL(string: music.playUrl) else {
            return
        }
        player = AVPlayer(url: playUrl)
        setupEvent(music: music)
    }
    
    func setupEvent(music: Music) {
        self.music = music
        controlView.isPlaying = false
        iconView.sd_setImage(with: URL(string: music.animeInfo.logo))
        titleLabel.text = music.animeInfo.title
        authorView.text = music.author
        SDWebImageDownloader.shared.downloadImage(with: URL(string: music.animeInfo.bg)) { image, _, _, _  in
            self.backgroundImageView.image =  image ?? UIImage()
            self.progressView.progressTintColor = UIColor(patternImage: image ?? UIImage())
        }
        self.playListView.reloadData()
    }
    
    func setPlayList(_ playList: [Music]) {
        self.playList = playList
    }
    
    func playMusic() {
        controlView.isPlaying = true
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
    
    @objc func updateProgress() {
        guard self.player.currentItem?.duration.seconds != 0 else {
            return
        }
        let progress = Float(self.player.currentTime().seconds / (self.player.currentItem?.duration.seconds ?? 0))
        if progress == 1 {
            let PlayMode = UserDefaults.standard.integer(forKey: LZUDKeys.PlayMode.rawValue)
            switch PlayMode {
            case 1:
                setupPlayerView(music: playList[currentMusicIndex])
                playMusic()
            case 2:
                guard playList.count > 1 else {
                    currentMusicIndex = 0
                    setupPlayerView(music: playList[currentMusicIndex])
                    return
                }
                playList.remove(at: currentMusicIndex)
                currentMusicIndex = Int(arc4random_uniform(UInt32(playList.count)))
            case 3:
                guard currentMusicIndex < playList.count - 1 else {
                    setupPlayerView(music: playList[currentMusicIndex])
                    return
                }
                currentMusicIndex += 1
            default:
                guard currentMusicIndex < playList.count - 1 else {
                    currentMusicIndex = 0
                    return
                }
                currentMusicIndex += 1
            }
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
            self.playMode = .ListOrder
        case .ListOrder:
            self.playMode = .ListRepeating
        }
    }
    
    override func scaleTo(_ isEnlarge: Bool, completionHandler: @escaping () -> Void) {

        if isEnlarge {
            super.scaleTo(isEnlarge) {
                completionHandler()
                self.backgroundImageView.isHidden = true
            }
            titleViewBackgroundView.isHidden = true
            authorView.isHidden = true
            likedBtn.isHidden = true
            addBtn.isHidden = true
            playModeBtn.isHidden = true
            playListBtn.isHidden = true
            progressView.isHidden = true
            iconView.scaleTo(isEnlarge)
            titleLabel.scaleTo(isEnlarge)
            controlView.scaleTo(isEnlarge)
        }else {
            backgroundImageView.isHidden = false
            super.scaleTo(isEnlarge) {
                completionHandler()
                self.titleViewBackgroundView.isHidden = false
                self.authorView.isHidden = false
                self.likedBtn.isHidden = false
                self.addBtn.isHidden = false
                self.playModeBtn.isHidden = false
                self.playListBtn.isHidden = false
                self.progressView.isHidden = false
            }
            iconView.scaleTo(isEnlarge)
            titleLabel.scaleTo(isEnlarge)
            controlView.scaleTo(isEnlarge)
        }
    }
}

extension MusicDetailView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        playList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCell") as? LZMusicCell
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
