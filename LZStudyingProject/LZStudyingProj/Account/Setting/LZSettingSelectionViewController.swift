//
//  LZSettingSelectionViewController.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/31.
//

import Foundation
import TMComponent
import UIKit

class LZSettingSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var selectedRow: Int?
    var dataSource: [String] = []
    var completionHandler: (String) -> Void = { _ in }
    lazy var selectionTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(selectionTableView)
        selectionTableView.backgroundColor = UIColor(named: "BackgroundGray")
        selectionTableView.dataSource = self
        selectionTableView.delegate = self
        selectionTableView.register(LZSettingSelectionCell.self, forCellReuseIdentifier: "SettingSelectionCell")
        selectionTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        dataSource.count
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        118
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        if title == "显示模式" {
            let selectedAppearance = AppearanceSetting(userDisplayName: dataSource[indexPath.row])
            UserDefaults.standard.set(selectedAppearance.userDisplayName, forKey: "AppleAppearance")

            if let window = selectionTableView.window {
                if selectedAppearance == .Dark {
                    window.overrideUserInterfaceStyle = .dark
                } else if selectedAppearance == .Light {
                    window.overrideUserInterfaceStyle = .light
                } else {
                    window.overrideUserInterfaceStyle = .unspecified
                }
            }

            select(at: indexPath)
            completionHandler(selectedAppearance.userDisplayName)
        }
    }

    func select(at indexPath: IndexPath) {
        if let lastSelected = selectedRow {
            let cell = selectionTableView.cellForRow(at: IndexPath(row: lastSelected, section: 0))
            cell?.isSelected = false
        }
        selectedRow = indexPath.row
        let cell = selectionTableView.cellForRow(at: indexPath) as? LZSettingSelectionCell
        cell?.isSelected = true
    }

    func changeToLanguage(languageCode: String) {
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        exit(1)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingSelectionCell") as?  LZSettingSelectionCell
        cell?.setupEvent(title: dataSource[indexPath.row])
        cell?.selectionStyle = .none
        if title == "显示模式" {
            if dataSource[indexPath.row] == UserDefaults.standard.string(forKey: "AppleAppearance") {
                cell?.isSelected = true
                selectedRow = indexPath.row
            }
        }
        cell?.addObserver(cell ?? UITableViewCell(), forKeyPath: "isBeenSelected", options: [.new, .old], context: nil)
        return cell ?? UITableViewCell()
    }
}
