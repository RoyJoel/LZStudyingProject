//
//  LZBillingViewController.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/24.
//

import Foundation
import UIKit

class LZBillingViewController: UIViewController {
    var order = Order()
    var isCart = false

    lazy var checkoutTitleView: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var billView: LZBillingView = {
        let view = LZBillingView()
        view.isOrderCell = false
        return view
    }()

    lazy var addressView: LZAddressView = {
        let view = LZAddressView()
        return view
    }()

    lazy var wayOfPayView: LZPaymentView = {
        let view = LZPaymentView()
        return view
    }()

    lazy var deliWayLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var deliWayView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var deliWayBackgroundView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var discBackgroundView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var discLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var discView: UIView = {
        let view = UIView()
        return view
    }()

    lazy var totalLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var totalNumLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var confirmBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor(named: "ContentBackground")
        view = LZBillVCView()
        view.addSubview(checkoutTitleView)
        view.addSubview(billView)
        view.addSubview(addressView)
        view.addSubview(wayOfPayView)
        view.addSubview(deliWayBackgroundView)
        deliWayBackgroundView.addSubview(deliWayLabel)
        deliWayBackgroundView.addSubview(deliWayView)
        view.addSubview(discBackgroundView)
        discBackgroundView.addSubview(discLabel)
        discBackgroundView.addSubview(discView)
        view.addSubview(totalLabel)
        view.addSubview(totalNumLabel)
        view.addSubview(confirmBtn)

        checkoutTitleView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(48)
            make.width.equalTo(108)
            make.height.equalTo(30)
        }

        billView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalTo(checkoutTitleView.snp.bottom).offset(12)
            make.height.equalTo(126)
            make.right.equalToSuperview().offset(-24)
        }
        addressView.snp.makeConstraints { make in
            make.left.equalTo(billView.snp.left)
            make.top.equalTo(billView.snp.bottom).offset(24)
            make.width.equalToSuperview().dividedBy(2).offset(-24)
            make.bottom.equalToSuperview().offset(-24)
        }
        wayOfPayView.frame = CGRect(x: 208, y: 240, width: UIScreen.main.bounds.width - 232, height: 68)

        totalLabel.snp.makeConstraints { make in
            make.left.equalTo(wayOfPayView.snp.left)
            make.bottom.equalTo(confirmBtn.snp.top).offset(-24)

            make.height.equalTo(50)
        }

        totalNumLabel.snp.makeConstraints { make in
            make.right.equalTo(wayOfPayView.snp.right)
            make.bottom.equalTo(totalLabel.snp.bottom)
            make.height.equalTo(50)
        }

        confirmBtn.snp.makeConstraints { make in
            make.right.equalTo(wayOfPayView.snp.right)
            make.bottom.equalToSuperview().offset(-24)
            make.width.equalTo(108)
            make.height.equalTo(50)
        }

        totalLabel.text = "总计"
        totalLabel.font = UIFont.systemFont(ofSize: 26)

        let totalNum = LZDataConvert.getTotalPrice(order.bills)
        totalNumLabel.text = "¥" + String(format: "%.2f", totalNum)
        totalNumLabel.font = UIFont.systemFont(ofSize: 22)

        checkoutTitleView.text = "结账"
        checkoutTitleView.font = UIFont.systemFont(ofSize: 23)
        billView.setup(with: order.bills)
        billView.backgroundColor = UIColor(named: "ComponentBackground")
        billView.setCorner(radii: 15)
        addressView.setupUI()
        addressView.setupEvent(address: LZUser.user.defaultAddress)
        wayOfPayView.setupUI()
        wayOfPayView.setCorner(radii: 15)
        wayOfPayView.backgroundColor = UIColor(named: "ComponentBackground")
        wayOfPayView.setupEvent(title: "支付方式", info: "wechat")
        wayOfPayView.clipsToBounds = false

        confirmBtn.setTitle("支付", for: .normal)
        confirmBtn.backgroundColor = UIColor(named: "TennisBlur")
        confirmBtn.setTitleColor(.black, for: .normal)
        confirmBtn.addTarget(self, action: #selector(pay), for: .touchDown)
        confirmBtn.setCorner(radii: 15)
    }

    @objc func pay() {
        var newOrder = OrderRequest(id: order.id, bills: order.bills, shippingAddress: order.shippingAddress, payment: order.payment, playerId: LZUser.user.id, createdTime: order.createdTime, payedTime: Date().timeIntervalSince1970, state: .ToSend)
        if isCart {
            newOrder.id = LZUser.user.cart
            LZUser.assignCart(order: newOrder) { _ in
                let toastView = UILabel()
                toastView.text = NSLocalizedString("支付成功", comment: "")
                toastView.numberOfLines = 2
                toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                toastView.backgroundColor = UIColor(named: "ComponentBackground")
                toastView.textAlignment = .center
                toastView.setCorner(radii: 15)
                self.view.showToast(toastView, duration: 1, point: CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)) { _ in
                    self.navigationController?.dismiss(animated: true)
                }
            }
        } else {
            LZOrderRequest.addOrder(order: newOrder) { _ in
                let toastView = UILabel()
                toastView.text = NSLocalizedString("支付成功", comment: "")
                toastView.numberOfLines = 2
                toastView.bounds = CGRect(x: 0, y: 0, width: 350, height: 150)
                toastView.backgroundColor = UIColor(named: "ComponentBackground")
                toastView.textAlignment = .center
                toastView.setCorner(radii: 15)
                self.view.showToast(toastView, duration: 1, point: CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)) { _ in
//                    points -= Int(LZDataConvert.getTotalPrice(newOrder.bills))
//                    let record = pointRecord(date: Date().timeIntervalSince1970, type: .exchange, num: Int(LZDataConvert.getTotalPrice(newOrder.bills)))
//                    records.append(record)
                    self.navigationController?.dismiss(animated: true)
                }
            }
        }
    }
}
