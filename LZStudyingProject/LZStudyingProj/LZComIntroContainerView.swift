//
//  LZComIntroContainerView.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/22.
//

import Foundation
import JXSegmentedView
import UIKit

class LZComIntroContainerView: UIImageView, JXSegmentedListContainerViewListDelegate {
    override init(image: UIImage?) {
        super.init(image: image)
        contentMode = .scaleAspectFit
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func listView() -> UIView {
        return self
    }
}
