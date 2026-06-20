//
//  SwipeGestureBridge.swift
//  Bloom
//
//  Created by Аскольд on 20.06.2026.
//

import SwiftUI
import UIKit

struct GlobalSwipeGestureModifier: ViewModifier {
    @Binding var progress: CGFloat
    let isPresented: Bool
    let onEnded: (Bool) -> Void
    
    func body(content: Content) -> some View {
        content.background(
            GlobalSwipeGestureView(progress: $progress, isPresented: isPresented, onEnded: onEnded)
        )
    }
}

struct GlobalSwipeGestureView: UIViewRepresentable {
    @Binding var progress: CGFloat
    let isPresented: Bool
    let onEnded: (Bool) -> Void
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.isHidden = true
        
        DispatchQueue.main.async {
            if let window = view.window {
                let gesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
                gesture.delegate = context.coordinator
                
                gesture.cancelsTouchesInView = false
                
                window.addGestureRecognizer(gesture)
                context.coordinator.gesture = gesture
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.parent = self
    }
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    static func dismantleUIView(_ uiView: UIView, coordinator: Coordinator) {
        if let gesture = coordinator.gesture, let view = gesture.view {
            view.removeGestureRecognizer(gesture)
        }
    }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var parent: GlobalSwipeGestureView
        weak var gesture: UIPanGestureRecognizer?
        
        init(_ parent: GlobalSwipeGestureView) { self.parent = parent }
        
        @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
            guard let view = recognizer.view else { return }
            let translation = recognizer.translation(in: view)
            let velocity = recognizer.velocity(in: view).x
            let width = view.bounds.width
            
            switch recognizer.state {
            case .changed:
                let delta = translation.x / width
                parent.progress = max(0.0, min(1.0, 1.0 - delta))
                
            case .ended, .cancelled:
                let shouldClose = translation.x > width * 0.3 || velocity > 300
                parent.onEnded(shouldClose)
                
            default: break
            }
        }
        
        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            guard let pan = gestureRecognizer as? UIPanGestureRecognizer, let view = pan.view else { return false }
            let translation = pan.translation(in: view)
            return parent.isPresented && translation.x > 0 && abs(translation.y) < abs(translation.x)
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
    }
}
