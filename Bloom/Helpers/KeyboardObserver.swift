//
//  KeyboardObserver.swift
//  Bloom
//
//  Created by Аскольд on 24.06.2026.
//

import SwiftUI
import Combine

@Observable
@MainActor
class KeyboardObserver {
    var height: CGFloat = 0
    var duration: Double = 0.25
    var animation: Animation = .easeOut(duration: 0.25)
    var offset: CGFloat
    var visible: Bool = false
    var progress: CGFloat = 0
    
    private var cancellables = Set<AnyCancellable>()
    
    init(offset: CGFloat = 0) {
        self.offset = offset
        
        let showPublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
        let hidePublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
        let changePublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
        
        Publishers.Merge3(showPublisher, hidePublisher, changePublisher)
            .sink { [weak self] notification in
                self?.handle(notification)
            }
            .store(in: &cancellables)
    }
    
    private func handle(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
        let screenHeight = UIScreen.main.bounds.height
        
        if notification.name == UIResponder.keyboardWillHideNotification || keyboardFrame.origin.y >= screenHeight {
            self.visible = false
            self.height = 0
            withAnimation(animation) {
                self.progress = 0
            }
        } else {
            self.visible = true
            self.height = max(0, keyboardFrame.height - offset)
            withAnimation(animation) {
                self.progress = 1
            }
        }
        
        self.duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25
        
        if let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int {
            if curveValue == 7 {
                self.animation = .interpolatingSpring(mass: 3, stiffness: 1000, damping: 500)
            } else {
                switch curveValue {
                case 0: self.animation = .easeInOut(duration: duration)
                case 1: self.animation = .easeIn(duration: duration)
                case 2: self.animation = .easeOut(duration: duration)
                case 3: self.animation = .linear(duration: duration)
                default: self.animation = .easeOut(duration: duration)
                }
            }
        } else {
            self.animation = .easeOut(duration: duration)
        }
    }
}
