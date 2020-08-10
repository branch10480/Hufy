//
//  UIImage+.swift
//  hufy
//
//  Created by 今枝 稔晴 on 2020/08/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit

extension UIImage {
    /// 指定した色の 1pt * 1pt UIImage を生成
    static func create(withColor color: UIColor) -> UIImage? {
        let _size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContext(_size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: _size.width, height: _size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
        
        
    }
}
