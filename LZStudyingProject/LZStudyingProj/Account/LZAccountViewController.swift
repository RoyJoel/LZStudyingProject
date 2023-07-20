//
//  AccountViewController.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/26.
//

import Foundation
import SwiftyJSON
import TMComponent
import UIKit

class LZAccountViewController: TMViewController {
    lazy var settingView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "gearshape")
        return imageView
    }()

    lazy var iconView: TMIconView = {
        let iconView = TMIconView()
        return iconView
    }()

    lazy var pointLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var likedMusicBtn: TMBasicButton = {
        let view = TMBasicButton()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(settingView)
        view.addSubview(iconView)
        view.addSubview(pointLabel)
        view.addSubview(likedMusicBtn)

        let iconConfig = TMIconViewConfig(icon: LZUser.shared.user.icon.toPng(), name: LZUser.shared.user.name)
        iconView.setupEvent(config: iconConfig)
        settingView.tintColor = UIColor(named: "ContentBackground")
        settingView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(58)
            make.left.equalToSuperview().offset(44)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }

        pointLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }

        likedMusicBtn.snp.makeConstraints { make in
            make.top.equalTo(pointLabel.snp.bottom).offset(24)
            make.height.equalTo(68)
            make.centerX.equalToSuperview()
            make.width.equalTo(138)
        }
        
        iconView.snp.makeConstraints { make in
            make.top.equalTo(settingView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(164)
            make.height.equalTo(240)
        }
        settingView.isUserInteractionEnabled = true
        settingView.addTapGesture(self, #selector(settingViewUp))
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: Notification.Name(ToastNotification.DataFreshToast.rawValue), object: nil)

        let likedMusicBtnConfig = TMButtonConfig(title: "我的喜欢", action: #selector(viewMyMusic), actionTarget: self)
        likedMusicBtn.setupEvent(config: likedMusicBtnConfig)
    }

    @objc func settingViewUp() {
        let vc = LZSettingViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navigationController?.present(navVC, animated: true)
    }

    @objc func refreshData() {
        let iconConfig = TMIconViewConfig(icon: LZUser.shared.user.icon.toPng(), name: LZUser.shared.user.name)
        iconView.setupEvent(config: iconConfig)
    }

    @objc func viewMyMusic() {
        let vc = LZUserLikedMusicViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
