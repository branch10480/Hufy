//
//  HapticFeedbackServiceProtocol.swift
//  hufy
//
//  Created by branch10480 on 2020/09/05.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit

protocol HapticFeedbackServiceProtocol {
    func prepareImpactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle)
    func impactFeedback()
    func prepareSelectionFeedback()
    func selectionFeedback()
    func prepareNotificationFeedback()
    func notificationFeedback(style: UINotificationFeedbackGenerator.FeedbackType)
}
