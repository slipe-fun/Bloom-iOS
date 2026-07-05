//
//  TrackKeyboardHeight.swift
//  Bloom
//
//  Created by Аскольд on 05.07.2026.
//

import SwiftUI
import UIKit


final class KeyboardHeightTracker: NSObject, ObservableObject {

    @Published private(set) var height: CGFloat = 0

    private weak var window: UIWindow?
    private weak var ghost: UIView?
    private var displayLink: CADisplayLink?

    private var kvoContext = 0
    private var isObserving = false

    private let epsilon: CGFloat = 0.05

    func install(in window: UIWindow) {
        guard self.window !== window else { return }
        teardown()

        guard let rootView = window.rootViewController?.view else { return }

        self.window = window

        let ghost = UIView(frame: .zero)
        ghost.isHidden = true
        ghost.isUserInteractionEnabled = false
        ghost.backgroundColor = .clear
        rootView.addSubview(ghost)

        ghost.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ghost.leadingAnchor.constraint(equalTo: rootView.leadingAnchor),
            ghost.trailingAnchor.constraint(equalTo: rootView.trailingAnchor),
            ghost.topAnchor.constraint(equalTo: rootView.keyboardLayoutGuide.topAnchor),
            ghost.bottomAnchor.constraint(equalTo: rootView.bottomAnchor)
        ])

        self.ghost = ghost
        ghost.layer.addObserver(self, forKeyPath: "bounds", options: [.new], context: &kvoContext)
        isObserving = true
    }

    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        guard context == &kvoContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        startDisplayLinkIfNeeded()
    }

    private func startDisplayLinkIfNeeded() {
        guard displayLink == nil else { return }
        let link = CADisplayLink(target: self, selector: #selector(tick))
        link.add(to: .main, forMode: .common)
        displayLink = link
    }

    @objc private func tick() {
        guard let ghost, let window else {
            stopDisplayLink()
            return
        }
        guard let presentation = ghost.layer.presentation() else { return }

        let inset = window.safeAreaInsets.bottom
        let modelHeight = ghost.layer.bounds.height
        let newHeight = max(0, presentation.bounds.height - inset)

        if abs(newHeight - height) > epsilon {
            height = newHeight
        }

        if abs(presentation.bounds.height - modelHeight) < epsilon {
            height = max(0, modelHeight - inset)
            stopDisplayLink()
        }
    }

    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }

    private func teardown() {
        stopDisplayLink()
        if isObserving, let ghost {
            ghost.layer.removeObserver(self, forKeyPath: "bounds", context: &kvoContext)
        }
        isObserving = false
        ghost?.removeFromSuperview()
    }

    deinit {
        displayLink?.invalidate()
        if isObserving, let ghost {
            ghost.layer.removeObserver(self, forKeyPath: "bounds", context: &kvoContext)
        }
    }
}

private struct KeyboardWindowFinder: UIViewRepresentable {

    final class ProbeView: UIView {
        var onWindow: ((UIWindow) -> Void)?
        override func didMoveToWindow() {
            super.didMoveToWindow()
            if let window { onWindow?(window) }
        }
    }

    let tracker: KeyboardHeightTracker

    func makeUIView(context: Context) -> ProbeView {
        let view = ProbeView(frame: .zero)
        view.isHidden = true
        view.isUserInteractionEnabled = false
        view.onWindow = { [weak tracker] window in
            tracker?.install(in: window)
        }
        return view
    }

    func updateUIView(_ uiView: ProbeView, context: Context) {}
}

struct KeyboardHeightReader<Content: View>: View {
    @StateObject private var tracker = KeyboardHeightTracker()
    private let content: (CGFloat) -> Content

    init(@ViewBuilder content: @escaping (CGFloat) -> Content) {
        self.content = content
    }

    var body: some View {
        content(tracker.height)
            .background(
                KeyboardWindowFinder(tracker: tracker)
                    .frame(width: 0, height: 0)
            )
    }
}
