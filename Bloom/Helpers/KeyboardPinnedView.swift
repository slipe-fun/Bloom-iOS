//
//  KeyboardPinnedView.swift
//  Bloom
//
//  Created by Аскольд on 24.06.2026.
//

import SwiftUI
import UIKit

struct KeyboardPinnedView<Content: View>: UIViewControllerRepresentable {
    @Binding var keyboardHeight: CGFloat
    @Binding var footerHeight: CGFloat
    @Binding var isKeyboardVisible: Bool
    let content: Content
    
    init(
        keyboardHeight: Binding<CGFloat>,
        footerHeight: Binding<CGFloat>,
        isKeyboardVisible: Binding<Bool>,
        @ViewBuilder content: () -> Content
    ) {
        self._keyboardHeight = keyboardHeight
        self._footerHeight = footerHeight
        self._isKeyboardVisible = isKeyboardVisible
        self.content = content()
    }
    
    func makeUIViewController(context: Context) -> KeyboardPinnedViewController<Content> {
        KeyboardPinnedViewController(
            rootView: content,
            keyboardHeight: $keyboardHeight,
            footerHeight: $footerHeight,
            isKeyboardVisible: $isKeyboardVisible
        )
    }
    
    func updateUIViewController(_ uiViewController: KeyboardPinnedViewController<Content>, context: Context) {
        uiViewController.hostingController.rootView = content
    }
}

final class TouchThroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        return hitView == self ? nil : hitView
    }
}

final class MeasuringHostingController<Content: View>: UIHostingController<Content> {
    var onLayoutSubviews: (() -> Void)?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.invalidateIntrinsicContentSize()
        onLayoutSubviews?()
    }
}

final class KeyboardPinnedViewController<Content: View>: UIViewController {
    let hostingController: MeasuringHostingController<Content>
    @Binding var keyboardHeight: CGFloat
    @Binding var footerHeight: CGFloat
    @Binding var isKeyboardVisible: Bool
    
    private var lastKeyboardHeight: CGFloat = -1
    private var lastFooterHeight: CGFloat = -1
    private var lastIsKeyboardVisible: Bool? = nil
    
    init(
        rootView: Content,
        keyboardHeight: Binding<CGFloat>,
        footerHeight: Binding<CGFloat>,
        isKeyboardVisible: Binding<Bool>
    ) {
        self.hostingController = MeasuringHostingController(rootView: rootView)
        self._keyboardHeight = keyboardHeight
        self._footerHeight = footerHeight
        self._isKeyboardVisible = isKeyboardVisible
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func loadView() {
        self.view = TouchThroughView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        view.keyboardLayoutGuide.usesBottomSafeArea = false
        hostingController.safeAreaRegions = []
        
        hostingController.view.backgroundColor = .clear
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        ])
        
        hostingController.onLayoutSubviews = { [weak self] in
            self?.updateMeasurements()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateMeasurements()
    }
    
    private func updateMeasurements() {
        let minY = view.keyboardLayoutGuide.layoutFrame.minY
        let currentKeyboardHeight = (minY > 0 && minY < view.bounds.height) ? (view.bounds.height - minY) : 0
        let currentFooterHeight = hostingController.view.bounds.height
        let currentIsKeyboardVisible = currentKeyboardHeight > 0
        
        let heightsChanged = currentKeyboardHeight != lastKeyboardHeight || currentFooterHeight != lastFooterHeight
        let visibilityChanged = currentIsKeyboardVisible != lastIsKeyboardVisible
        
        guard heightsChanged || visibilityChanged else { return }
        
        if heightsChanged {
            lastKeyboardHeight = currentKeyboardHeight
            lastFooterHeight = currentFooterHeight
            self.keyboardHeight = currentKeyboardHeight
            self.footerHeight = currentFooterHeight
        }
        
        if visibilityChanged {
            lastIsKeyboardVisible = currentIsKeyboardVisible
            
            Task { @MainActor [weak self] in
                guard let self else { return }
                var transaction = Transaction()
                transaction.disablesAnimations = true
                withTransaction(transaction) {
                    self.isKeyboardVisible = currentIsKeyboardVisible
                }
            }
        }
    }
}
