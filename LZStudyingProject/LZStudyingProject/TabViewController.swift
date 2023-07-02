//
//  TabViewController.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/15.
//

import Foundation
import SnapKit
import UIKit
import AVFoundation

class TabViewController: UITabBarController {
    lazy var eventVC: LZShoppingViewController = {
        let vc = LZShoppingViewController()
        return vc
    }()
    lazy var accountVC: LZAccountViewController = {
        let vc = LZAccountViewController()
        return vc
    }()
    lazy var expressVC: LZMusicViewController = {
        let vc = LZMusicViewController()
        return vc
    }()
    lazy var playerView: MusicDetailView = {
        let view = MusicDetailView()
        return view
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
            playMusic(at: newValue)
        }
    }
    
    var isPlayerViewScaled: Bool = false {
        willSet {
            if newValue {
                self.timer = Timer(timeInterval: 0.1, target: self, selector: #selector(self.updateProgress), userInfo: nil, repeats: true)
                RunLoop.current.add(self.timer, forMode: .default)
            }else {
                self.timer.invalidate()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = UIColor(named: "ComponentBackground")
        tabBar.tintColor = UIColor(named: "Tennis")
        tabBar.unselectedItemTintColor = UIColor(named: "ContentBackground")
        tabBar.setCorner(radii: 15)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playMusic(_:)), name: Notification.Name(ToastNotification.PlayMusic.rawValue), object: nil)

        if #available(iOS 15.0, *) {
            let appearnce = UITabBarAppearance()
            appearnce.configureWithOpaqueBackground()
            appearnce.backgroundColor = UIColor(named: "ComponentBackground")
            tabBar.standardAppearance = appearnce
            tabBar.scrollEdgeAppearance = appearnce
        }

        addViewController()
        layoutPlayerView()
        setupPlayer()
    }
    
    func layoutPlayerView() {
        view.insertSubview(playerView, belowSubview: tabBar)
        playerView.frame = CGRect(x: 24, y: view.frame.size.height - 83 - 18, width: view.frame.size.width - 48, height: 83)
        playerView.setupUI()
        playerView.completionHandler = { res in
            if res == true {
                self.player.play()
            }else {
                self.player.pause()
            }
        }
    }
    
    func setupPlayer() {
        player.volume = 1.0
        player.allowsExternalPlayback = true
        player.actionAtItemEnd = .none
    }
    
    override func viewDidLayoutSubviews() {
        var frame = tabBar.frame
        frame.size.width = view.frame.size.width - 48
        frame.origin.x = 24
        frame.origin.y = view.frame.size.height - frame.size.height - 18
        tabBar.frame = frame
    }
    
    @objc func playMusic(_ obj: Notification) {
        guard let playList = obj.userInfo?["PlayList"] as? [Music] else {
            return
        }
        self.playList = playList
    }
    
    @objc func updateProgress() {
        guard self.player.currentItem?.duration.seconds != 0 else {
            return
        }
        let progress = Float(self.player.currentTime().seconds / (self.player.currentItem?.duration.seconds ?? 0))
        if progress == 1 {
            currentMusicIndex += 1
        }else {
            self.playerView.setProgress(progress)
        }
    }
    
    @objc func scalePlayerView(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
               let verticalMovement = translation.y
        if gesture.state == .ended {
            if verticalMovement > 0 {
                if playerView.toggle == true {
                    isPlayerViewScaled = false
                    playerView.scaleTo(true) {
                        self.tabBar.isHidden = self.playerView.toggle
                    }
                }
            }else {
                if playerView.toggle == false {
                    isPlayerViewScaled = true
                    playerView.scaleTo(false) { }
                    self.tabBar.isHidden = self.playerView.toggle
                }
            }
        }
    }
    
    func playMusic(at index: Int) {
        guard let playUrl = URL(string: playList[index].playUrl) else {
            return
        }
        playerView.setupEvent(music: playList[index])
        if playerView.frame == CGRect(x: 24, y: view.frame.size.height - tabBar.frame.size.height - 18, width: view.frame.size.width - 48, height: tabBar.frame.size.height) {
            playerView.addAnimation(CGPoint(x: playerView.layer.position.x, y: playerView.layer.position.y), CGPoint(x: playerView.layer.position.x, y: playerView.layer.position.y - tabBar.frame.size.height - 18), 0.3, "position")
            playerView.layer.position = CGPoint(x: playerView.layer.position.x, y: playerView.layer.position.y - tabBar.frame.size.height - 18)
            
            playerView.setup(playerView.bounds, playerView.layer.position, UIScreen.main.bounds, CGPoint(x: UIStandard.shared.screenWidth / 2, y: UIStandard.shared.screenHeight / 2), 0.3)
            
            playerView.addPanGesture(self, #selector(scalePlayerView(_:)))
        }
        player = AVPlayer(url: playUrl)
        player.play()
    }

    private func addViewController() {
        setChildViewController(expressVC, NSLocalizedString("音乐", comment: ""), "shippingbox")
        setChildViewController(eventVC, NSLocalizedString("会员商城", comment: ""), "trophy")
        setChildViewController(accountVC, NSLocalizedString("我的", comment: ""), "figure.tennis")
    }

    private func setChildViewController(_ childViewController: UIViewController, _ itemName: String, _ itemImage: String) {
        childViewController.title = itemName
        childViewController.tabBarItem.title = itemName
        childViewController.tabBarItem.image = UIImage(systemName: itemImage)

        let nav = UINavigationController(rootViewController: childViewController)
        addChild(nav)
    }
}
