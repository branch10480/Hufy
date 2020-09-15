//
//  AppFlowService.swift
//  hufy
//
//  Created by branch10480 on 2020/09/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit

final class AppFlowService: AppFlowServiceProtocol {
    
    func relaunch() {
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return
        }
        let vc = EntryViewController()
        keyWindow.rootViewController = vc
    }
}
