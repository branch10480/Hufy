//
//  BaseButton.swift
//  hufy
//
//  Created by branch10480 on 2020/08/14.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit

class BaseButton: UIButton {
    
    enum DesignType {
        case defaultDesign
        case cancelDesign
    }
    var type: DesignType = .defaultDesign {
        didSet {
            refresh()
        }
    }
    var radius: CGFloat = .buttonHeight / 2 {
        didSet {
            refresh()
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            refresh()
        }
    }
    
    private func refresh() {
        switch type {
        case .defaultDesign:
            setDefaultDesign(radius: radius)
        case .cancelDesign:
            setCancelDesign(radius: radius)
        }
    }

}
