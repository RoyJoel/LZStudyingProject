//
//  DoubleExtension.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/11.
//

import Foundation

extension Double {
    func TwoBitsRem() -> Int {
        Int(self * 10000) / 100
    }
}
