//
//  LZSettingInfoViewController.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/7.
//

import Foundation
import TMComponent
import UIKit

class LZSettingInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var titleSettingConfig = ["姓名", "头像", "性别", "年龄"]
    var infoSettingConfig = [LZUser.shared.user.name, "", LZUser.shared.user.sex.rawValue, "\(LZUser.shared.user.age)"]
    let infoVC = LZSignUpViewController()

    let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setLeftBarButton(UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancel)), animated: true)
        navigationItem.setRightBarButton(UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(updateUserInfo)), animated: true)
        view.backgroundColor = UIColor(named: "BackgroundGray")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        tableView.backgroundColor = UIColor(named: "BackgroundGray")
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LZSettingUserIconCell.self, forCellReuseIdentifier: "SettingUserIconCell")
        tableView.register(LZSettingTableViewCell.self, forCellReuseIdentifier: "SettingTableViewCell")
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingUserIconCell") as?  LZSettingUserIconCell
            let indexTitle = titleSettingConfig[indexPath.row]
            cell?.setupEvent(title: indexTitle, icon: LZUser.shared.user.icon.toPng())
            cell?.selectionStyle = .none
            return cell ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell") as?  LZSettingTableViewCell
            let indexTitle = titleSettingConfig[indexPath.row]
            cell?.setupEvent(title: indexTitle, info: infoSettingConfig[indexPath.row])
            cell?.selectionStyle = .none
            return cell ?? UITableViewCell()
        }
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        infoVC.showSubView(tag: indexPath.row + 200)
        infoVC.completionHandler = { result in
            (self.tableView.cellForRow(at: indexPath) as? LZSettingTableViewCell)?.setupEvent(title: self.titleSettingConfig[indexPath.row], info: result)
        }
        infoVC.iconCompletionHandler = { [weak self] icon in
            guard let self = self else {
                return
            }
            (self.tableView.cellForRow(at: indexPath) as? LZSettingUserIconCell)?.setupEvent(title: self.titleSettingConfig[indexPath.row], icon: icon)
        }
        navigationController?.pushViewController(infoVC, animated: true)
        infoVC.setUserInfo()
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        98
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        titleSettingConfig.count
    }

    @objc func cancel() {
        let sheetCtrl = UIAlertController(title: "取消修改", message: nil, preferredStyle: .alert)

        let action = UIAlertAction(title: "确认", style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }
            
            self.navigationController?.popViewController(animated: true)
        }
        sheetCtrl.addAction(action)

        let cancelAction = UIAlertAction(title: "取消", style: .default) { [weak self] _ in
            guard let self = self else {
                return
            }
            
            sheetCtrl.dismiss(animated: true)
        }
        sheetCtrl.addAction(cancelAction)

        sheetCtrl.popoverPresentationController?.sourceView = view
        sheetCtrl.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.width / 2 - 144, y: view.bounds.height / 2 - 69, width: 288, height: 138)
        present(sheetCtrl, animated: true, completion: nil)
    }

    @objc func updateUserInfo() {
        let sheetCtrl = UIAlertController(title: "保存修改", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "确认", style: .default) { _ in
            
            
            self.infoVC.getUserInfo()
            LZUserRequest.updateInfo { [weak self] user, error in
                guard let self = self else {
                    return
                }
                guard user != nil else {
                    self.view.showToast(with: "更新信息失败")
                    return
                }
                guard error == nil else {
                    self.view.showToast(with: "更新信息失败")
                    return
                }
                self.view.showToast(with: "更新信息成功")
                let userInfo = try? PropertyListEncoder().encode(LZUser.shared.user)
                UserDefaults.standard.set(userInfo, forKey: LZUDKeys.UserInfo.rawValue)
                NotificationCenter.default.post(name: Notification.Name(ToastNotification.DataFreshToast.notificationName.rawValue), object: nil)
                self.navigationController?.popViewController(animated: true)
            }
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
