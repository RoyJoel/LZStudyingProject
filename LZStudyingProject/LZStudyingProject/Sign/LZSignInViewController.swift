//
//  LZSignInViewController.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/2.
//

import AVKit
import Foundation
import TMComponent
import UIKit

class LZSignInViewController: AVPlayerViewController {
    lazy var loginNameTextField: TMTextField = {
        let textField = TMTextField()
        return textField
    }()

    lazy var passwordTextField: TMTextField = {
        let textField = TMTextField()
        return textField
    }()

    lazy var signUpBtn: TMButton = {
        let btn = TMButton()
        return btn
    }()

    lazy var signInBtn: LZSignInBtn = {
        let btn = LZSignInBtn()
        return btn
    }()

    lazy var forgetPasswordBtn: TMButton = {
        let btn = TMButton()
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // 创建 AVPlayer 对象
        guard let videoURL = Bundle.main.url(forResource: "loginViewVideo", withExtension: "mov") else {
            return
        }
        let player = AVPlayer(url: videoURL)
        // 创建 AVPlayerViewController 对象
        self.player = player
        allowsPictureInPicturePlayback = false
        // 设置播放器样式
        videoGravity = .resizeAspectFill
        showsPlaybackControls = false
        player.play() // 开始播放视频
        player.volume = 0
        player.allowsExternalPlayback = true
        player.actionAtItemEnd = .none
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { [weak player] _ in
            player?.seek(to: .zero)
            player?.play()
        }
        // 设置音频会话并激活它
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playback, mode: .default, options: [.mixWithOthers])
        try? session.setActive(true)

        contentOverlayView?.addSubview(loginNameTextField)
        contentOverlayView?.addSubview(passwordTextField)
        contentOverlayView?.addSubview(signInBtn)
        contentOverlayView?.addSubview(forgetPasswordBtn)
        contentOverlayView?.addSubview(signUpBtn)
        loginNameTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(348)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(loginNameTextField.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        signUpBtn.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(12)
            make.left.equalTo(passwordTextField.snp.centerX).offset(12)
            make.width.equalTo(138)
            make.height.equalTo(48)
        }
        forgetPasswordBtn.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(12)
            make.right.equalTo(passwordTextField.snp.centerX).offset(-12)
            make.width.equalTo(138)
            make.height.equalTo(48)
        }
        signInBtn.frame = CGRect(x: UIScreen.main.bounds.width / 2 - 75, y: 530, width: 150, height: 150)
        signInBtn.setupView()
        loginNameTextField.setup(with: TMTextFieldConfig(placeholderText: "Login Name"))
        passwordTextField.setup(with: TMTextFieldConfig(placeholderText: "Password"))
        let signUpBtnConfig = TMButtonConfig(title: "Newer? signup", action: #selector(signUpVCUp), actionTarget: self)
        signUpBtn.setUp(with: signUpBtnConfig)
        let forgetPasswordBtnConfig = TMButtonConfig(title: "Forget passWord?", action: #selector(resetPasswordVCUp), actionTarget: self)
        forgetPasswordBtn.setUp(with: forgetPasswordBtnConfig)
        // 设置 completion 回调
        signInBtn.completion = { [weak self] in
            guard let self = self else {
                return
            }
            // 在这里处理登录接口返回数据之前的逻辑
            if let loginName = self.loginNameTextField.textField.text, let password = self.passwordTextField.textField.text {
                if !loginName.isEmpty, !password.isEmpty {
                    LZUser.user.loginName = loginName
                    LZUser.user.password = password
                    LZUser.signIn { user, error in
                        guard error == nil else {
                            if let window = self.signInBtn.window {
                                let toastView = UILabel()
                                toastView.text = NSLocalizedString("login failed", comment: "")
                                toastView.numberOfLines = 2
                                toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                                toastView.backgroundColor = UIColor(named: "ComponentBackground")
                                toastView.textAlignment = .center
                                toastView.setCorner(radii: 15)
                                (window.rootViewController as? LZSignInViewController)?.contentOverlayView?.showToast(toastView, duration: 1, point: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)) { _ in
                                }
                            }
                            self.signInBtn.stopBouncing()
                            return
                        }
                        guard let user = user else {
                            if let window = self.signInBtn.window {
                                let toastView = UILabel()
                                toastView.text = NSLocalizedString("login failed", comment: "")
                                toastView.numberOfLines = 2
                                toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                                toastView.backgroundColor = UIColor(named: "ComponentBackground")
                                toastView.textAlignment = .center
                                toastView.setCorner(radii: 15)
                                (window.rootViewController as? LZSignInViewController)?.contentOverlayView?.showToast(toastView, duration: 1, point: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)) { _ in
                                }
                            }
                            self.signInBtn.stopBouncing()
                            return
                        }
                        LZUser.user = user
                        var loggedinUser = (UserDefaults.standard.array(forKey: LZUDKeys.loggedinUser.rawValue) as? [String]) ?? []
                        loggedinUser.append(LZUser.user.loginName)
                        let userInfo = try? PropertyListEncoder().encode(LZUser.user)
                        UserDefaults.standard.set(loggedinUser, forKey: LZUDKeys.loggedinUser.rawValue)
                        UserDefaults.standard.set(userInfo, forKey: LZUDKeys.UserInfo.rawValue)
                        UserDefaults.standard.set(user.token, forKey: LZUDKeys.JSONWebToken.rawValue)
                        // 登录成功后，跳转到下一个界面
                        if let window = self.signInBtn.window {
                            let homeVC = TabViewController()
                            window.rootViewController = homeVC
                        }
                        self.signInBtn.stopBouncing()
                    }
                } else {
                    if let window = self.signInBtn.window {
                        let toastView = UILabel()
                        toastView.text = NSLocalizedString("loginName can not be null", comment: "")
                        toastView.numberOfLines = 2
                        toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                        toastView.backgroundColor = UIColor(named: "ComponentBackground")
                        toastView.textAlignment = .center
                        toastView.setCorner(radii: 15)
                        (window.rootViewController as? LZSignInViewController)?.contentOverlayView?.showToast(toastView, duration: 1, point: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)) { _ in
                        }
                    }
                    self.signInBtn.stopBouncing()
                }
            } else {
                if let window = self.signInBtn.window {
                    let toastView = UILabel()
                    toastView.text = NSLocalizedString("loginName can not be null", comment: "")
                    toastView.numberOfLines = 2
                    toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                    toastView.backgroundColor = UIColor(named: "ComponentBackground")
                    toastView.textAlignment = .center
                    toastView.setCorner(radii: 15)
                    (window.rootViewController as? LZSignInViewController)?.contentOverlayView?.showToast(toastView, duration: 1, point: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)) { _ in
                    }
                }
                self.signInBtn.stopBouncing()
            }
        }
    }

    @objc func signUpVCUp() {
        let vc = LZSignUpViewController()
        present(vc, animated: true)
    }

    @objc func resetPasswordVCUp() {
        let vc = LZResetPasswordViewController()
        present(vc, animated: true)
    }
}
