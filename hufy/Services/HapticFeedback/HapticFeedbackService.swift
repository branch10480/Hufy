//
//  HapticFeedbackService.swift
//  hufy
//
//  Created by branch10480 on 2020/09/05.
//  Copyright © 2020 Toshiharu Imaeda. All rights reserved.
//

import UIKit

final class HapticFeedbackService: HapticFeedbackServiceProtocol {
    
    private var impactFeedbackGenerator: UIImpactFeedbackGenerator?
    private var selectionFeedbackGenerator: UISelectionFeedbackGenerator?
    private let notificationFeedbackGenerator: UINotificationFeedbackGenerator = .init()
    
    func prepareImpactFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        impactFeedbackGenerator = UIImpactFeedbackGenerator(style: style)
        impactFeedbackGenerator?.prepare()
    }
    
    func impactFeedback() {
        impactFeedbackGenerator?.impactOccurred()
    }
    
    func prepareSelectionFeedback() {
        selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        selectionFeedbackGenerator?.prepare()
    }
    
    func selectionFeedback() {
        selectionFeedbackGenerator?.selectionChanged()
    }
    
    func prepareNotificationFeedback() {
        notificationFeedbackGenerator.prepare()
    }
    
    func notificationFeedback(style: UINotificationFeedbackGenerator.FeedbackType) {
        notificationFeedbackGenerator.notificationOccurred(style)
    }
    
    
}
