//
//  UIApplication+.swift
//  hufy
//
//  Created by branch10480 on 2020/09/22.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit

extension UIApplication {
    
    static var topViewController: UIViewController? {
        let vc = shared.keyWindow?.rootViewController
        return topVC(vc: vc)
    }
    
    private static func topVC(vc: UIViewController?) -> UIViewController? {
        
        if let tabController = vc as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topVC(vc: selected)
            }
        }
        
        if let navigationController = vc as? UINavigationController {
            return topVC(vc: navigationController.visibleViewController)
        }
        
        if let presented = vc?.presentedViewController {
            return topVC(vc: presented)
        }
        
        return vc
    }
}
