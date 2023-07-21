//
//  LZSettingViewController.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/30.
//

import Foundation
import TMComponent
import UIKit

class LZSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var settingConfig = ["显示模式": [AppearanceSetting.Light.userDisplayName, AppearanceSetting.Dark.userDisplayName, AppearanceSetting.UnSpecified.userDisplayName], "听歌缓存": [], "Info": [""]]
    let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    lazy var signOutBtn: TMBasicButton = {
        let btn = TMBasicButton()
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "BackgroundGray")
        navigationController?.navigationBar.tintColor = UIColor(named: "ContentBackground")
        view.addSubview(tableView)
        view.addSubview(signOutBtn)
        tableView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(signOutBtn.snp.top).offset(-5)
        }
        signOutBtn.snp.makeConstraints { make in
            make.width.equalTo(88)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5)
        }
        tableView.backgroundColor = UIColor(named: "BackgroundGray")
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LZSettingIconCell.self, forCellReuseIdentifier: "SettingIconCell")
        tableView.register(LZSettingTableViewCell.self, forCellReuseIdentifier: "SettingTableViewCell")
        let signOutBtnConfig = TMButtonConfig(title: "退出登录", action: #selector(signOut), actionTarget: self)
        signOutBtn.setupEvent(config: signOutBtnConfig)
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingIconCell") as?  LZSettingIconCell
            cell?.selectionStyle = .none
            cell?.isUserInteractionEnabled = false
            return cell ?? UITableViewCell()
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell") as?  LZSettingTableViewCell
            if indexPath.row == 1 {
                cell?.setupEvent(title: "显示模式", info: UserDefaults.standard.string(forKey: "AppleAppearance") ?? "UnSpecified")
            }else if indexPath.row == 2 {
                cell?.setupEvent(title: "听歌缓存", info: "")
            }else {
                cell?.setupEvent(title: "个人信息", info: "")
            }
            cell?.selectionStyle = .none
            return cell ?? UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? LZSettingTableViewCell
        if indexPath.row < 2 {
            let vc = LZSettingSelectionViewController()
            vc.title = cell?.titleView.text
            let configs = ["显示模式"]
            vc.dataSource = settingConfig[configs[indexPath.row - 1]] ?? []
            vc.completionHandler = { result in
                if indexPath.row == 1 {
                    cell?.setupEvent(title: "显示模式", info: result)
                }
            }
            navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 2 {
            let vc = LZCacheSettingViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = LZSettingInfoViewController()
            vc.isModalInPresentation = true
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 292
        } else {
            return 98
        }
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        settingConfig.keys.count + 1
    }

    @objc func signOut() {
        let sheetCtrl = UIAlertController(title: "确定退出登录？", message: nil, preferredStyle: .alert)

        let action = UIAlertAction(title: "确认", style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }
            
            if let window = self.signOutBtn.window {
                UserDefaults.standard.set(nil, forKey: LZUDKeys.JSONWebToken.rawValue)
                UserDefaults.standard.set(nil, forKey: LZUDKeys.UserInfo.rawValue)
                window.rootViewController = LZSignInViewController()
            }
            self.navigationController?.popViewController(animated: true)
        }
        sheetCtrl.addAction(action)

        let cancelAction = UIAlertAction(title: "取消", style: .default) { _ in
            sheetCtrl.dismiss(animated: true)
        }
        sheetCtrl.addAction(cancelAction)

        sheetCtrl.popoverPresentationController?.sourceView = view
        sheetCtrl.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.width / 2 - 144, y: view.bounds.height / 2 - 69, width: 288, height: 138)
        present(sheetCtrl, animated: true, completion: nil)
    }
}
