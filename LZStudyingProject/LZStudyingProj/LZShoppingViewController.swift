//
//  LZShoppingViewController.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/26.
//

import Alamofire
import Foundation
import MapKit
import SwiftyJSON
import TMComponent
import UIKit

class LZShoppingViewController: TMViewController {
    var layout = LZFlowLayout(commodities: [])

    lazy var titleView: UILabel = {
        let label = UILabel()
        return label
    }()

    lazy var filter: LZFilterView = {
        let view = LZFilterView()
        return view
    }()

    lazy var shoppingCollectionView: LZShoppingCollectionView = {
        let view = LZShoppingCollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()

    lazy var cartBtn: UIButton = {
        let btn = UIButton()
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view = LZEventView()
        view.addSubview(titleView)
        view.addSubview(filter)
        view.addSubview(shoppingCollectionView)
        view.addSubview(cartBtn)
        view.bringSubviewToFront(filter)

        titleView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.top.equalToSuperview().offset(60)
            make.width.equalTo(208)
            make.height.equalTo(44)
        }

        cartBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-24)
            make.top.equalToSuperview().offset(60)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }

        LZCommodityRequest.getAll { commodities in
            self.layout = LZFlowLayout(commodities: commodities)
            self.shoppingCollectionView.collectionViewLayout = self.layout
            self.shoppingCollectionView.coms = commodities
            self.layout.collectionView?.reloadData()
        }

        cartBtn.setImage(UIImage(systemName: "cart"), for: .normal)
        cartBtn.setCorner(radii: 22)
        cartBtn.tintColor = UIColor(named: "ContentBackground")
        cartBtn.backgroundColor = UIColor(named: "ComponentBackground")
        cartBtn.addTarget(self, action: #selector(enterBillView), for: .touchDown)
        titleView.font = UIFont.systemFont(ofSize: 24)

        filter.frame = CGRect(x: UIStandard.shared.screenWidth - 170, y: 60, width: 90, height: 44)

        filter.setup(filter.bounds, filter.layer.position, CGRect(x: 0, y: 0, width: 270, height: filter.bounds.height), CGPoint(x: filter.layer.position.x - 28, y: filter.layer.position.y), 0.3)

        shoppingCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(12)
            make.left.equalTo(titleView.snp.left)
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-98)
        }

        filter.setupUI()
        filter.clipsToBounds = false

        titleView.text = "会员商城"
        filter.completionHandler = { coms in
            self.shoppingCollectionView.applyFilter(coms: coms)
        }
    }

    @objc func enterBillView() {
        let vc = LZBillTableViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navigationController?.present(navVC, animated: true)
        vc.openCartMode()
    }
}
