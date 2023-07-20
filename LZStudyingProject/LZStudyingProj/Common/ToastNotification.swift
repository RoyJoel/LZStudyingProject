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
    case RefreshExpressData
    // 刷新订单信息
    case RefreshOrderData
    // 播放音乐
    case PlayMusic

    /// 通知名称
    var notificationName: NSNotification.Name {
        return NSNotification.Name(rawValue)
    }
}
