//
//  LZMusicViewController.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/15.
//

import Foundation
import TMComponent
import UIKit

class LZMusicViewController: UITableViewController {
    var music: [Music] = []

    lazy var alartView: UILabel = {
        let label = UILabel()
        return label
    }()

    override func viewDidLoad() {
        view.backgroundColor = UIColor(named: "BackgroundGray")
        view.addSubview(alartView)
        tableView.backgroundColor = UIColor(named: "BackgroundGray")

        alartView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tableView.register(LZComBillingCell.self, forCellReuseIdentifier: "billing")
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.delegate = self
        
        LZMusicRequest.getAll { music in
            if music.count == 0 {
                self.setupAlart()
            } else {
                self.music = music
                self.tableView.reloadData()
            }
        }
        
        tableView.isHidden = false
        alartView.isHidden = true
    }

    func setupAlart() {
        tableView.isHidden = true
        alartView.isHidden = false
        alartView.text = NSLocalizedString("空空如也", comment: "")
        alartView.font = UIFont.systemFont(ofSize: 22)
        alartView.textAlignment = .center
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return music.count
    }

    override func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 118
    }

    override func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LZMusicCell()
        cell.setupEvent(music: music[indexPath.row])
        return cell
    }
}
