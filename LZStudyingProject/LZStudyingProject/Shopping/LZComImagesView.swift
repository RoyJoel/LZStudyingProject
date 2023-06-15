//
//  LZComImagesView.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/22.
//

import Foundation
import JXSegmentedView
import TMComponent
import UIKit

class LZComImagesView: TMView {
    let segmentedView = JXSegmentedView()
    var intros: [String] = []
    lazy var listContainerView: JXSegmentedListContainerView! = {
        JXSegmentedListContainerView(dataSource: self)
    }()
    func setupUI() {
        setCorner(radii: 20)
        backgroundColor = UIColor(named: "BackgroundGray")

        segmentedView.listContainer = listContainerView
        addSubview(listContainerView)

        listContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}

extension LZComImagesView: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in _: JXSegmentedListContainerView) -> Int {
        intros.count
    }

    func listContainerView(_: JXSegmentedListContainerView, initListAt: Int) -> JXSegmentedListContainerViewListDelegate {
        let containerView = LZComIntroContainerView(image: UIImage(data: intros[initListAt].toPng()))
        return containerView
    }
}

extension LZComImagesView: JXSegmentedViewDelegate {
    func segmentedView(_: JXSegmentedView, didSelectedItemAt _: Int) {}
}
