//
//  EdgeSwipeGestureView.swift
//  Bloom
//
//  Created by Аскольд on 20.06.2026.
//

import SwiftUI
import UIKit

struct EdgeSwipeGestureView: UIViewRepresentable {
    @Binding var dragOffset: CGFloat
    @Binding var isSwiping: Bool
    let screenWidth: CGFloat
    let onPop: () -> Void
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        let gesture = UIScreenEdgePanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        gesture.edges = .left
        gesture.delegate = context.coordinator
        view.addGestureRecognizer(gesture)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var parent: EdgeSwipeGestureView
        
        init(_ parent: EdgeSwipeGestureView) {
            self.parent = parent
        }
        
        @objc func handlePan(_ recognizer: UIScreenEdgePanGestureRecognizer) {
            guard let view = recognizer.view else { return }
            let translation = recognizer.translation(in: view)
            let velocityX = recognizer.velocity(in: view).x
            let width = parent.screenWidth
            
            switch recognizer.state {
            case .began:
                parent.isSwiping = true
                parent.dragOffset = 0
            case .changed:
                let x = translation.x
                if x > width {
                    parent.dragOffset = width + (x - width) * 0.38
                } else {
                    parent.dragOffset = max(0, x)
                }
            case .ended, .cancelled:
                let translationX = translation.x
                let shouldPop = translationX > width * 0.35 || velocityX > 300
                
                if shouldPop {
                    withAnimation(.normalSpring) {
                        parent.dragOffset = width
                    }
                    
                    Task { @MainActor in
                        try? await Task.sleep(for: .seconds(0.38))
                        
                        var transaction = Transaction(animation: .none)
                        transaction.disablesAnimations = true
                        withTransaction(transaction) {
                            self.parent.onPop()
                            self.parent.isSwiping = false
                            self.parent.dragOffset = 0
                        }
                    }
                } else {
                    withAnimation(.normalSpring) {
                        parent.dragOffset = 0
                    }
                    
                    Task { @MainActor in
                        try? await Task.sleep(for: .seconds(0.35))
                        
                        self.parent.isSwiping = false
                    }
                }
            default:
                parent.isSwiping = false
                parent.dragOffset = 0
            }
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return false
        }
    }
}

@MainActor
class HapticManager {
    static let shared = HapticManager()
    
    private let selectionGenerator = UISelectionFeedbackGenerator()
    
    private var hapticTask: Task<Void, Never>?
    
    private init() {
        selectionGenerator.prepare()
    }
    
    func triggerSettingsOpeningHaptic() {
        hapticTask?.cancel()
        
        hapticTask = Task {
            try? await Task.sleep(for: .seconds(0.08))
            
            guard !Task.isCancelled else { return }
            
            self.selectionGenerator.selectionChanged()
            self.selectionGenerator.prepare()
        }
    }
}
