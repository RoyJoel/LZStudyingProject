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
    var titleSettingConfig = ["Name", "Icon", "Sex", "Age"]
    var infoSettingConfig = [LZUser.user.name, "", LZUser.user.sex.rawValue, "\(LZUser.user.age)"]
    let infoVC = LZSignUpViewController()

    let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setLeftBarButton(UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel)), animated: true)
        navigationItem.setRightBarButton(UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(updateUserInfo)), animated: true)
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
        tableView.register(LZSettingTableViewCell.self, forCellReuseIdentifier: "LZSettingTableViewCell")
        infoVC.setUserInfo(name: LZUser.user.name, icon: LZUser.user.icon.toPng(), sex: LZUser.user.sex, age: LZUser.user.age)
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 {
            let cell = LZSettingUserIconCell()
            let indexTitle = titleSettingConfig[indexPath.row]
            cell.setupEvent(title: indexTitle, icon: LZUser.user.icon.toPng())
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = LZSettingTableViewCell()
            let indexTitle = titleSettingConfig[indexPath.row]
            cell.setupEvent(title: indexTitle, info: infoSettingConfig[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        infoVC.showSubView(tag: indexPath.row + 200)
        infoVC.completionHandler = { result in
            (self.tableView.cellForRow(at: indexPath) as? LZSettingTableViewCell)?.setupEvent(title: self.titleSettingConfig[indexPath.row], info: result)
        }
        infoVC.iconCompletionHandler = { icon in
            (self.tableView.cellForRow(at: indexPath) as? LZSettingUserIconCell)?.setupEvent(title: self.titleSettingConfig[indexPath.row], icon: icon)
        }
        navigationController?.pushViewController(infoVC, animated: true)
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        98
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        titleSettingConfig.count
    }

    @objc func cancel() {
        let sheetCtrl = UIAlertController(title: "Cancel changes", message: nil, preferredStyle: .alert)

        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        sheetCtrl.addAction(action)

        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            sheetCtrl.dismiss(animated: true)
        }
        sheetCtrl.addAction(cancelAction)

        sheetCtrl.popoverPresentationController?.sourceView = view
        sheetCtrl.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.width / 2 - 144, y: view.bounds.height / 2 - 69, width: 288, height: 138)
        present(sheetCtrl, animated: true, completion: nil)
    }

    @objc func updateUserInfo() {
        let sheetCtrl = UIAlertController(title: "Save changes", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            self.infoVC.getUserInfo()
            let usericonData = LZUser.user.icon
            LZUser.updateInfo { user in
                guard let user = user else {
                    return
                }
                print(usericonData.count == user.icon.count)
                let userInfo = try? PropertyListEncoder().encode(LZUser.user)
                UserDefaults.standard.set(userInfo, forKey: LZUDKeys.UserInfo.rawValue)
                NotificationCenter.default.post(name: Notification.Name(ToastNotification.DataFreshToast.notificationName.rawValue), object: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
        sheetCtrl.addAction(action)

        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            sheetCtrl.dismiss(animated: true)
        }
        sheetCtrl.addAction(cancelAction)

        sheetCtrl.popoverPresentationController?.sourceView = view
        sheetCtrl.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.width / 2 - 144, y: view.bounds.height / 2 - 69, width: 288, height: 138)
        present(sheetCtrl, animated: true, completion: nil)
    }
}
