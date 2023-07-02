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
    
    lazy var blurBackgroundView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        return view
    }()
    
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var completionHandler: ((Bool) -> Void)? {
        willSet {
            controlView.completionHandler = newValue
        }
    }
    
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
        
        backgroundImageView.frame = CGRect(x: 0, y: 0, width: UIStandard.shared.screenWidth, height: UIStandard.shared.screenHeight)
        backgroundImageView.image = UIImage()
        backgroundImageView.contentMode = .scaleAspectFill
        blurBackgroundView.effect = UIBlurEffect(style: .light)
        blurBackgroundView.frame = CGRect(x: 0, y: 0, width: UIStandard.shared.screenWidth, height: UIStandard.shared.screenHeight)
        iconView.frame = CGRect(x: 12, y: 6, width: bounds.height - 12, height: bounds.height - 12)
        
        controlView.frame = CGRect(x: bounds.width - 120, y: 6, width: 108, height: bounds.height - 12)
        
        titleLabel.frame = CGRect(x: bounds.height + 6, y: 0, width: bounds.width - bounds.height - 6 - 120, height: bounds.height)
        
        
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
        
        playModeBtn.setImage(UIImage(systemName: "repeat")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), for: .normal)
        playListBtn.setImage(UIImage(systemName: "list.bullet")?.withTintColor((UIColor(named: "ContentBackground") ?? .black), renderingMode: .alwaysOriginal), for: .normal)
        
        controlView.setupUI()
        
        iconView.setCorner(radii: 10)
        iconView.contentMode = .scaleAspectFill
        iconView.clipsToBounds = true
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.tintColor = UIColor(named: "ContentBackground")
        titleViewBackgroundView.backgroundColor = UIColor(named: "BackgroundGray")
        authorView.textColor = UIColor(named: "SubTitleTintColor")
        
        progressView.setCorner(radii: 10)
        
        iconView.setup(iconView.bounds, iconView.layer.position, CGRect(x: 0, y: 0, width: 232, height: 232), CGPoint(x: UIStandard.shared.screenWidth / 2, y: 248), 0.3)
        titleLabel.setup(titleLabel.bounds, titleLabel.layer.position, CGRect(x: 0, y: 0, width: UIStandard.shared.screenWidth - 72, height: 25), CGPoint(x: UIStandard.shared.screenWidth / 2, y: 498), 0.3)
        controlView.setup(controlView.bounds, controlView.layer.position, CGRect(x: 0, y: 0, width: UIStandard.shared.screenWidth / 2, height: 68), CGPoint(x: UIStandard.shared.screenWidth / 2, y: 734), 0.3)
        
        backgroundImageView.isHidden = true
        titleViewBackgroundView.isHidden = true
        authorView.isHidden = true
        likedBtn.isHidden = true
        addBtn.isHidden = true
        playModeBtn.isHidden = true
        playListBtn.isHidden = true
        progressView.isHidden = true
    }
    
    func setupEvent(music: Music) {
        controlView.isPlaying = true
        iconView.sd_setImage(with: URL(string: music.animeInfo.logo))
        titleLabel.text = music.animeInfo.title
        authorView.text = music.author
        SDWebImageDownloader.shared.downloadImage(with: URL(string: music.animeInfo.bg)) { image, _, _, _  in
            self.backgroundImageView.image =  image ?? UIImage()
            self.progressView.progressTintColor = UIColor(patternImage: image ?? UIImage())
        }
        
    }
    
    func setProgress(_ progress: Float) {
        progressView.setProgress(progress, animated: true)
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



