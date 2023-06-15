//
//  LZUserOrderTableView.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/29.
//

import Foundation
import JXSegmentedView
import UIKit

class LZUserOrderTableView: UITableView {}

extension LZUserOrderTableView: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self
    }
}
