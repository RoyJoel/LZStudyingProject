//
//  LZEventView.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/15.
//

import Foundation
import TMComponent
import UIKit

class LZEventView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: "BackgroundGray")
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        for view in subviews {
            if view is LZFilterView {
                for subview in view.subviews {
                    if subview is TMPopUpView, subview.isHidden == false, CGRectContainsPoint(subview.frame, CGPoint(x: point.x - view.frame.minX, y: point.y - view.frame.minY)) {
                        return subview
                    }
                }
            }
        }
        return super.hitTest(point, with: event)
    }
}
