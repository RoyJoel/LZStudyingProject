//
//  ToastNotification.swift
//  LZStudyingProject
//
//  Created by Jason Zhang on 2023/6/15.
//

import Foundation
import UIKit

enum ToastNotification: String {
    case DataFreshToast
    case HomeViewToast
    case AddGameToast
    case ContinueGameToast
    case DataSavingToast
    // 刷新快递信息
    case refreshExpressData
    // 刷新订单信息
    case refreshOrderData

    /// 通知名称
    var notificationName: NSNotification.Name {
        return NSNotification.Name(rawValue)
    }
}
