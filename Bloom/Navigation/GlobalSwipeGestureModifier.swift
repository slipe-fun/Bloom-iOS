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
            let velocity = recognizer.velocity(in: view).x
            let width = UIScreen.main.bounds.width
            
            switch recognizer.state {
            case .began:
                parent.isSwiping = true
                parent.dragOffset = 0
            case .changed:
                parent.dragOffset = max(0, translation.x)
            case .ended, .cancelled:
                let shouldPop = translation.x > width * 0.35 || velocity > 300
                if shouldPop {
                    withAnimation(.normalSpring) {
                        parent.dragOffset = width
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.parent.onPop()
                        self.parent.isSwiping = false
                        self.parent.dragOffset = 0
                    }
                } else {
                    withAnimation(.normalSpring) {
                        parent.dragOffset = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
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
