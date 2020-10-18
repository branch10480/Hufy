//
//  Design.swift
//  hufy
//
//  Created by branch10480 on 2020/08/22.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit
import Kingfisher

protocol DesignCompatible {
    associatedtype CompatibleType
    
    var design: CompatibleType { get }
}

extension UIView: DesignCompatible {}

extension DesignCompatible {
    var design: Design<Self> {
        return Design(self)
    }
}

final class Design<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

// MARK: - UIView+
extension Design where Base == UIView {

    func textField() {
        base.layer.borderWidth = 2
        base.layer.borderColor = UIColor.other2.cgColor
        base.layer.cornerRadius = 4
    }
    
    func textView() {
        base.layer.borderWidth = 2
        base.layer.borderColor = UIColor.other2.cgColor
        base.layer.cornerRadius = 4
    }
}
