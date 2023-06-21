//
//  AccountViewController.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/26.
//

import Foundation
import SwiftyJSON
import TMComponent
import UIKit

class LZAccountViewController: TMViewController {
    var points = 110
    var lastClockTime: TimeInterval = 1_685_701_396
    lazy var settingView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "gearshape")
        return imageView
    }()

    lazy var clockInBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()

    lazy var iconView: TMIconView = {
        let iconView = TMIconView()
        return iconView
    }()

    lazy var pointLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var userOrderView: TMButton = {
        let view = TMButton()
        return view
    }()

    lazy var userExpressOrderView: TMButton = {
        let view = TMButton()
        return view
    }()

    lazy var pointRecordView: TMButton = {
        let btn = TMButton()
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(settingView)
        view.addSubview(clockInBtn)
        view.addSubview(iconView)
        view.addSubview(pointLabel)
        view.addSubview(userOrderView)
        view.addSubview(userExpressOrderView)
        view.addSubview(pointRecordView)

        let iconConfig = TMIconViewConfig(icon: LZUser.user.icon.toPng(), name: LZUser.user.name)
        iconView.setupEvent(config: iconConfig)
        settingView.tintColor = UIColor(named: "ContentBackground")
        settingView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(58)
            make.left.equalToSuperview().offset(44)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        clockInBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.top.equalToSuperview().offset(58)
            make.width.equalTo(108)
            make.height.equalTo(40)
        }

        pointLabel.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }

        userOrderView.snp.makeConstraints { make in
            make.top.equalTo(pointLabel.snp.bottom).offset(24)
            make.height.equalTo(68)
            make.centerX.equalToSuperview()
            make.width.equalTo(138)
        }
        userExpressOrderView.snp.makeConstraints { make in
            make.top.equalTo(userOrderView.snp.bottom).offset(24)
            make.height.equalTo(68)
            make.centerX.equalToSuperview()
            make.width.equalTo(138)
        }
        pointRecordView.snp.makeConstraints { make in
            make.top.equalTo(userExpressOrderView.snp.bottom).offset(24)
            make.height.equalTo(68)
            make.centerX.equalToSuperview()
            make.width.equalTo(138)
        }
        iconView.snp.makeConstraints { make in
            make.top.equalTo(settingView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(164)
            make.height.equalTo(240)
        }
        settingView.isUserInteractionEnabled = true
        settingView.addTapGesture(self, #selector(settingViewUp))
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData), name: Notification.Name(ToastNotification.DataFreshToast.rawValue), object: nil)
//        let userOrderConfig = TMButtonConfig(title: "快递订单", action: #selector(viewAllExpresses), actionTarget: self)
//        userOrderView.setupEvent(config: userOrderConfig)

        let userEOrderConfig = TMButtonConfig(title: "积分商城订单", action: #selector(viewAllOrders), actionTarget: self)
        userExpressOrderView.setupEvent(config: userEOrderConfig)

//        let pointRecordConfig = TMButtonConfig(title: "积分历史", action: #selector(viewAllPointRecord), actionTarget: self)
//        pointRecordView.setupEvent(config: pointRecordConfig)

        pointLabel.text = "当前积分：\(points)"
        clockInBtn.setTitle("打卡", for: .normal)
        clockInBtn.setTitleColor(UIColor(named: "ContentBackground"), for: .normal)
        clockInBtn.setImage(UIImage(systemName: "calendar.badge.clock"), for: .normal)
        clockInBtn.tintColor = UIColor(named: "ContentBackground")
        clockInBtn.setCorner(radii: 10)
        clockInBtn.backgroundColor = UIColor(named: "ComponentBackground")
        clockInBtn.addTarget(self, action: #selector(clockIn), for: .touchDown)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pointLabel.text = "当前积分：\(points)"
    }

    @objc func clockIn() {
        if lastClockTime.convertToString(formatterString: "yyyy MM-dd") != Date().timeIntervalSince1970.convertToString(formatterString: "yyyy MM-dd") {
            let toastView = UILabel()
            toastView.text = NSLocalizedString("今日打卡完成", comment: "")
            toastView.numberOfLines = 2
            toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
            toastView.backgroundColor = UIColor(named: "ComponentBackground")
            toastView.textAlignment = .center
            toastView.setCorner(radii: 15)
            view.showToast(toastView, duration: 1, point: CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)) { _ in
//                let record = pointRecord(date: Date().timeIntervalSince1970, type: .clockIn, num: 6)
//                points += 6
//                lastClockTime = Date().timeIntervalSince1970
//                self.pointLabel.text = "当前积分：\(points)"
//                records.append(record)
            }
        } else {
            let toastView = UILabel()
            toastView.text = NSLocalizedString("今日已打卡", comment: "")
            toastView.numberOfLines = 2
            toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
            toastView.backgroundColor = UIColor(named: "ComponentBackground")
            toastView.textAlignment = .center
            toastView.setCorner(radii: 15)
            view.showToast(toastView, duration: 1, point: CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)) { _ in
            }
        }
    }

    @objc func settingViewUp() {
        let vc = LZSettingViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navigationController?.present(navVC, animated: true)
    }

    @objc func refreshData() {
        let iconConfig = TMIconViewConfig(icon: LZUser.user.icon.toPng(), name: LZUser.user.name)
        iconView.setupEvent(config: iconConfig)
    }

//    @objc func viewAllExpresses() {
//        let vc = LZUserExpressesViewController()
//        navigationController?.pushViewController(vc, animated: true)
//    }

    @objc func viewAllOrders() {
        let vc = LZUserOrdersViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

//    @objc func viewAllPointRecord() {
//        let vc = LZUserPointRecordViewController()
//        navigationController?.pushViewController(vc, animated: true)
//    }
}
