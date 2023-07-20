//
//  LZCacheSettingViewController.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/7/4.
//

import Foundation
import UIKit

class LZCacheSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var titleSettingConfig = ["听歌缓存"]
    var infoSettingConfig = [UserDefaults.standard.bool(forKey: LZUDKeys.SongCache.rawValue)]

    let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
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
        tableView.register(LZSettingToggleTableViewCell.self, forCellReuseIdentifier: "ToggleSettingCell")
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToggleSettingCell") as? LZSettingToggleTableViewCell
        let indexTitle = titleSettingConfig[indexPath.row]
        cell?.setupEvent(title: indexTitle, toggle: infoSettingConfig[indexPath.row])
        cell?.selectionStyle = .none
        return cell ?? UITableViewCell()
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        98
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        titleSettingConfig.count
    }
}
