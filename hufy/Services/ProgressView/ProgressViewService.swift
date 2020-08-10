//
//  ProgressViewService.swift
//  hufy
//
//  Created by 今枝 稔晴 on 2020/08/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit
import MBProgressHUD

class ProgressViewService: ProgressViewServiceProtocol {
    func show(view: UIView) {
        MBProgressHUD.showAdded(to: view, animated: true)
    }
    
    func dismiss(view: UIView) {
        MBProgressHUD.hide(for: view, animated: true)
    }
}
