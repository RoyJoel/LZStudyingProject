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
    
    var isPlayerViewScaled: Bool = false {
        willSet {
                self.playerView.setTimer(newValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = UIColor(named: "ComponentBackground")
        tabBar.tintColor = UIColor(named: "Tennis")
        tabBar.unselectedItemTintColor = UIColor(named: "ContentBackground")
        tabBar.setCorner(radii: 15)
        

        if #available(iOS 15.0, *) {
            let appearnce = UITabBarAppearance()
            appearnce.configureWithOpaqueBackground()
            appearnce.backgroundColor = UIColor(named: "ComponentBackground")
            tabBar.standardAppearance = appearnce
            tabBar.scrollEdgeAppearance = appearnce
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(playMusic(_:)), name: Notification.Name(ToastNotification.PlayMusic.rawValue), object: nil)

        addViewController()
        layoutPlayerView()
    }
    
    func layoutPlayerView() {
        view.insertSubview(playerView, belowSubview: tabBar)
        playerView.frame = CGRect(x: 24, y: view.frame.size.height - 83 - 18, width: view.frame.size.width - 48, height: 83)
        playerView.setupUI()
    }
    
    
    override func viewDidLayoutSubviews() {
        var frame = tabBar.frame
        frame.size.width = view.frame.size.width - 48
        frame.origin.x = 24
        frame.origin.y = view.frame.size.height - frame.size.height - 18
        tabBar.frame = frame
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
    
    @objc func playMusic(_ obj: Notification) {
        guard let playList = obj.userInfo?["PlayList"] as? [Music] else {
            return
        }
        playerView.setPlayList(playList)
        setupPlayerView()
    }
    
    func setupPlayerView() {
        if playerView.frame == CGRect(x: 24, y: view.frame.size.height - tabBar.frame.size.height - 18, width: view.frame.size.width - 48, height: tabBar.frame.size.height) {
            playerView.addAnimation(CGPoint(x: playerView.layer.position.x, y: playerView.layer.position.y), CGPoint(x: playerView.layer.position.x, y: playerView.layer.position.y - tabBar.frame.size.height - 18), 0.3, "position")
            playerView.layer.position = CGPoint(x: playerView.layer.position.x, y: playerView.layer.position.y - tabBar.frame.size.height - 18)
            
            playerView.setup(playerView.bounds, playerView.layer.position, UIScreen.main.bounds, CGPoint(x: UIStandard.shared.screenWidth / 2, y: UIStandard.shared.screenHeight / 2), 0.3)
            playerView.addPanGesture(self, #selector(scalePlayerView(_:)))
        }
        
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
