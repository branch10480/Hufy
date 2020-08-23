//
//  UITextField+.swift
//  hufy
//
//  Created by branch10480 on 2020/08/22.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit

extension UITextField {

    func setup(placeholder ph: String?) {
        clearButtonMode = .whileEditing
        placeholder = ph
        font = UIFont.systemFont(ofSize: 16)
    }
}
