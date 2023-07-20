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
                        LZUser.shared.user = try PropertyListDecoder().decode(User.self, from: userInfo)
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
                    LZUser.shared.user = try PropertyListDecoder().decode(User.self, from: userInfo)
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
                    let neterror = error as? LZNetWorkError
                    switch neterror {
                    case .AuthError(""):
                        if let window = UIApplication.shared.windows.first {
                            (window.rootViewController as? LZSignInViewController)?.contentOverlayView?.showToast(with: "登录信息过期，请重新登录")
                            window.rootViewController = LZSignInViewController()
                        }
                    case .NetError(""):
                        if let window = UIApplication.shared.windows.first {
                            (window.rootViewController)?.view.showToast(with: "网络异常")
                        }
                    case .none:
                        break
                    case .some(_):
                        break
                    }
                    return
                }
                guard let userLoginName = userLoginName else {
                    return
                }
                guard let userPassword = userPassword else {
                    return
                }
                LZUser.shared.user.loginName = userLoginName
                LZUser.shared.user.password = userPassword
                LZUserRequest.signIn { user, error in
                    guard error == nil else {
                        let neterror = error as? LZNetWorkError
                        switch neterror {
                        case .AuthError(""):
                            if let window = UIApplication.shared.windows.first {
                                (window.rootViewController as? LZSignInViewController)?.contentOverlayView?.showToast(with: "登录信息过期，请重新登录")
                                window.rootViewController = LZSignInViewController()
                            }
                        case .NetError(""):
                            if let window = UIApplication.shared.windows.first {
                                (window.rootViewController)?.view.showToast(with: "网络异常")
                            }
                        case .none:
                            break
                        case .some(_):
                            break
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
