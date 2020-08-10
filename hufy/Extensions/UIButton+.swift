//
//  UIButton+.swift
//  hufy
//
//  Created by 今枝 稔晴 on 2020/08/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit

extension UIButton {

    func setDefaultDesign(radius: CGFloat) {
        setTitleColor(.buttonText, for: .normal)
        setBackgroundImage(UIImage.create(withColor: .buttonBackground), for: .normal)
        layer.cornerRadius = radius
        layer.masksToBounds = true
        titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    func setCancelDesign(radius: CGFloat) {
        setTitleColor(.buttonCancelText, for: .normal)
        setBackgroundImage(UIImage.create(withColor: .buttonCancelBackground), for: .normal)
        layer.cornerRadius = radius
        layer.masksToBounds = true
        titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    }
}
