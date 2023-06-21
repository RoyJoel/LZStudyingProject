//
//  LZClubContentView.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/14.
//

import Foundation
import TMComponent
import UIKit

class LZShoppingCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    var coms: [Commodity] = []
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = UIColor(named: "BackgroundGray")
        delegate = self
        dataSource = self
        register(LZCommodityCell.self, forCellWithReuseIdentifier: "commodityies")
        reloadData()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func applyFilter(coms: [Commodity]) {
        self.coms = coms
        reloadData()
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        coms.count
    }

    func collectionView(_: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: "commodityies", for: indexPath) as! LZCommodityCell
        cell.setupUI()
        if LZDataConvert.getPriceRange(with: coms[indexPath.row].options).0 == LZDataConvert.getPriceRange(with: coms[indexPath.row].options).1 {
            cell.setupEvent(icon: coms[indexPath.row].options[0].image, intro: coms[indexPath.row].name, price: "\(LZDataConvert.getPriceRange(with: coms[indexPath.row].options).0)", turnOver: coms[indexPath.row].orders)
        } else {
            cell.setupEvent(icon: coms[indexPath.row].options[0].image, intro: coms[indexPath.row].name, price: "\(LZDataConvert.getPriceRange(with: coms[indexPath.row].options).0) - \(LZDataConvert.getPriceRange(with: coms[indexPath.row].options).1)", turnOver: coms[indexPath.row].orders)
        }
        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = LZComContentViewController()
        vc.com = coms[indexPath.row]
        if let parentVC = getParentViewController() {
            parentVC.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
