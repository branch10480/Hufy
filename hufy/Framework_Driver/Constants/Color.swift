//
//  Color.swift
//  hufy
//
//  Created by 今枝 稔晴 on 2020/08/10.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit

extension UIColor {
    static var background: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemBackground
        } else {
            return #colorLiteral(red: 0.9998963475, green: 1, blue: 0.9955725074, alpha: 1)
        }
    }
    static let headerText: UIColor = #colorLiteral(red: 0.1517620683, green: 0.1381035149, blue: 0.2631978393, alpha: 1)
    static let text: UIColor = #colorLiteral(red: 0.176538676, green: 0.1990855038, blue: 0.2893102467, alpha: 1)
    static let buttonBackground: UIColor = #colorLiteral(red: 1, green: 0.8468388915, blue: 0.02265504748, alpha: 1)
    static let buttonText: UIColor = #colorLiteral(red: 0.1517620683, green: 0.1381035149, blue: 0.2631978393, alpha: 1)
    static let buttonCancelBackground: UIColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    static let buttonCancelText: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let buttonDisabledBackground: UIColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    static let buttonDisabledText: UIColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
    static let other1: UIColor = #colorLiteral(red: 0.7284123898, green: 0.9111635685, blue: 0.9082647562, alpha: 1)
    static let other2: UIColor = #colorLiteral(red: 0.9333333333, green: 0.9333333333, blue: 0.9333333333, alpha: 1)
    static let LINE: UIColor = #colorLiteral(red: 0.3067651987, green: 0.7178974748, blue: 0.2967447042, alpha: 1)
    static let sunday = #colorLiteral(red: 1, green: 0.4830381244, blue: 0.4324739558, alpha: 1)
    static let saturday = #colorLiteral(red: 0.3859322202, green: 0.6879526363, blue: 0.9686274529, alpha: 1)
    
    // check mark
    static let checkMarkNormal = UIColor.buttonDisabledBackground
    static let checkMarkActive = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
}
