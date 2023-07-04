//
//  LZSys.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/15.
//

import Foundation
import Reachability
import TABAnimated

class LZSys {
    var reachability: Reachability?
    static let shard = LZSys()
    private init() {}

    func initWindow() -> UIWindow {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        window.backgroundColor = .white
        window.overrideUserInterfaceStyle = initStyle()
        window.rootViewController = initRootViewController()
        window.makeKeyAndVisible()
        return window
    }

    func observeNetState() {
        if reachability == nil {
            do {
                reachability = try Reachability()
            } catch {
                print("Unable to create Reachability")
                return
            }

            reachability?.whenReachable = { _ in
                self.auth()
            }
            reachability?.whenUnreachable = { _ in
                if let userInfo = UserDefaults.standard.data(forKey: LZUDKeys.UserInfo.rawValue) {
                    do {
                        LZUser.user = try PropertyListDecoder().decode(User.self, from: userInfo)
                    } catch {
                        if let window = UIApplication.shared.windows.first {
                            window.rootViewController = LZSignInViewController()
                        }
                    }
                } else {
                    if let window = UIApplication.shared.windows.first {
                        window.rootViewController = LZSignInViewController()
                    }
                }
            }
        }
        try? reachability?.startNotifier()
    }

    func enterForeground() {
        if reachability?.connection != .unavailable {
            auth()
        }
    }

    func initRootViewController() -> UIViewController {
        let isNotFirstDownload = UserDefaults.standard.bool(forKey: LZUDKeys.isNotFirstDownload.rawValue)
        if !isNotFirstDownload {
            DispatchQueue.main.async {
                UserDefaults.standard.set(true, forKey: LZUDKeys.isNotFirstDownload.rawValue)
            }
            return LZSignInViewController()
        } else {
            if let userInfo = UserDefaults.standard.data(forKey: LZUDKeys.UserInfo.rawValue) {
                do {
                    LZUser.user = try PropertyListDecoder().decode(User.self, from: userInfo)
                    return TabViewController()
                } catch {
                    return LZSignInViewController()
                }
            } else {
                return LZSignInViewController()
            }
        }
    }

    func initStyle() -> UIUserInterfaceStyle {
        guard let appearance = UserDefaults.standard.string(forKey: "AppleAppearance") else {
            // 如果没有设置外观，则默认使用浅色模式。
            return .unspecified
        }
        let appearanceType = AppearanceSetting(userDisplayName: appearance)
        // 根据用户设置的外观来设置应用程序的外观。
        if appearanceType == .Dark {
            return .dark
        } else if appearanceType == .Light {
            return .light
        } else {
            return .unspecified
        }
    }

    func auth() {
        if let token = UserDefaults.standard.string(forKey: LZUDKeys.JSONWebToken.rawValue) {
            LZUser.auth(token: token) { userLoginName, userPassword, error in
                guard error == nil else {
                    if let window = UIApplication.shared.windows.first {
                        let signInVC = LZSignInViewController()
                        window.rootViewController = signInVC
                        let toastView = UILabel()
                        toastView.text = NSLocalizedString("The login information has expired\n please log in again", comment: "")
                        toastView.numberOfLines = 2
                        toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                        toastView.backgroundColor = UIColor(named: "ComponentBackground")
                        toastView.textAlignment = .center
                        toastView.setCorner(radii: 15)
                        (window.rootViewController as? LZSignInViewController)?.contentOverlayView?.showToast(toastView, duration: 1, point: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)) { _ in
                        }
                        window.rootViewController = LZSignInViewController()
                    }
                    return
                }
                guard let userLoginName = userLoginName else {
                    return
                }
                guard let userPassword = userPassword else {
                    return
                }
                LZUser.user.loginName = userLoginName
                LZUser.user.password = userPassword
                LZUser.signIn { user, error in
                    guard error == nil else {
                        if let window = UIApplication.shared.windows.first {
                            let toastView = UILabel()
                            toastView.text = NSLocalizedString("No such loginname or password", comment: "")
                            toastView.numberOfLines = 2
                            toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                            toastView.backgroundColor = UIColor(named: "ComponentBackground")
                            toastView.textAlignment = .center
                            toastView.setCorner(radii: 15)
                            (window.rootViewController as? LZSignInViewController)?.contentOverlayView?.showToast(toastView, duration: 1, point: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)) { _ in
                            }
                            window.rootViewController = LZSignInViewController()
                        }
                        return
                    }
                    NotificationCenter.default.post(name: Notification.Name(ToastNotification.DataFreshToast.notificationName.rawValue), object: nil)
                    UserDefaults.standard.set(user?.token, forKey: LZUDKeys.JSONWebToken.rawValue)
                }
            }
        } else {
            if let window = UIApplication.shared.windows.first {
                let signInVC = LZSignInViewController()
                window.rootViewController = signInVC
            }
        }
    }
}
