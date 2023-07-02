//
//  LZMusicViewController.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/15.
//

import Foundation
import TMComponent
import UIKit
import AVFoundation

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
        return 68
    }

    override func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LZMusicCell()
        cell.setupEvent(music: music[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if URL(string: music[indexPath.row].playUrl) != nil {
            let playList = Array(music[indexPath.row...])
            NotificationCenter.default.post(name: Notification.Name(ToastNotification.PlayMusic.rawValue), object: nil, userInfo: ["PlayList": playList])
        }else {
            let toastView = UILabel()
            toastView.text = NSLocalizedString("音乐信息失效", comment: "")
            toastView.numberOfLines = 2
            toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
            toastView.backgroundColor = UIColor(named: "ComponentBackground")
            toastView.textAlignment = .center
            toastView.setCorner(radii: 15)
            self.view.showToast(toastView, point: CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2))
        }
    }
}
