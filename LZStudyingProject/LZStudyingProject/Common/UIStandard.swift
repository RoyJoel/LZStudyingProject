//
//  UIStandard.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/15.
//
import Foundation
import UIKit

class UIStandard {
    static let shared = UIStandard()
    private init() {}
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
}
