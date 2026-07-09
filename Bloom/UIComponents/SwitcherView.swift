//
//  SwitcherView.swift
//  Bloom
//
//  Created by Аскольд on 09.07.2026.
//

import SwiftUI
import UIKit

final class GlassIconView: UIView {
    private let imageView = UIImageView()
    static let side: CGFloat = 30

    init(image: UIImage) {
        super.init(frame: .zero)
        isOpaque = false
        isUserInteractionEnabled = false
        
        imageView.image = image.withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not supported")
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        imageView.tintColor = tintColor
    }
    
    override var intrinsicContentSize: CGSize { CGSize(width: Self.side, height: Self.side) }
}

final class GlassSegmentedControl: UISegmentedControl {
    private var iconViews: [GlassIconView] = []
    static let inactiveOpacity: CGFloat = 0.4

    func setIcons(_ images: [UIImage]) {
        iconViews.forEach { $0.removeFromSuperview() }
        iconViews = images.map { GlassIconView(image: $0) }
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        hideAllNativeChrome()
        injectIconsIfNeeded()
        updateIconOpacities()
    }

    private func injectIconsIfNeeded() {
        let segments = findSegments()
        guard segments.count == iconViews.count else { return }
        for (i, segment) in segments.enumerated() {
            let icon = iconViews[i]
            if icon.superview == nil {
                icon.translatesAutoresizingMaskIntoConstraints = false
                segment.addSubview(icon)
                NSLayoutConstraint.activate([
                    icon.centerXAnchor.constraint(equalTo: segment.centerXAnchor),
                    icon.centerYAnchor.constraint(equalTo: segment.centerYAnchor),
                    icon.widthAnchor.constraint(equalToConstant: GlassIconView.side),
                    icon.heightAnchor.constraint(equalToConstant: GlassIconView.side),
                ])
            }
            segment.bringSubviewToFront(icon)
        }
    }
    
    private func updateIconOpacities() {
        for (i, icon) in iconViews.enumerated() {
            UIView.animate(withDuration: 0.15) {
                icon.alpha = (i == self.selectedSegmentIndex) ? 1.0 : Self.inactiveOpacity
            }
        }
    }

    private func hideAllNativeChrome() {
        hideRecursively(self)
    }

    private func hideRecursively(_ view: UIView) {
        for sub in view.subviews {
            if sub is GlassIconView { continue }
            
            let className = String(describing: type(of: sub))
            if className == "UISegment" {
                hideRecursively(sub)
                continue
            }
            
            if let label = sub as? UILabel {
                label.isHidden = true
            } else if let imageView = sub as? UIImageView {
                imageView.alpha = 0
            }
            
            hideRecursively(sub)
        }
    }

    private func findSegments() -> [UIView] {
        var result: [UIView] = []
        findSegments(in: self, into: &result)
        return result.sorted { $0.frame.minX < $1.frame.minX }
    }

    private func findSegments(in view: UIView, into result: inout [UIView]) {
        for sub in view.subviews {
            if String(describing: type(of: sub)) == "UISegment" {
                result.append(sub)
            } else {
                findSegments(in: sub, into: &result)
            }
        }
    }

    private func segmentIndex(at point: CGPoint) -> Int {
        guard numberOfSegments > 0 else { return 0 }
        let segmentWidth = bounds.width / CGFloat(numberOfSegments)
        return min(max(Int(point.x / segmentWidth), 0), numberOfSegments - 1)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let newIndex = segmentIndex(at: touch.location(in: self))
            if selectedSegmentIndex != newIndex {
                selectedSegmentIndex = newIndex
                sendActions(for: .valueChanged)
                updateIconOpacities()
            }
        }
        super.touchesMoved(touches, with: event)
    }
}

final class GlassSwitcherContainer: UIView {
    let glassView: UIVisualEffectView
    let control: GlassSegmentedControl

    static let segmentWidth: CGFloat = 77
    static let segmentHeight: CGFloat = 47
    static let containerPadding: CGFloat = 3
    static let containerHeight: CGFloat = segmentHeight + containerPadding * 2

    init(control: GlassSegmentedControl) {
        self.control = control

        let effect = UIGlassEffect(style: .clear)
        effect.isInteractive = true
        glassView = UIVisualEffectView(effect: effect)

        super.init(frame: .zero)

        control.selectedSegmentTintColor = UIColor.label.withAlphaComponent(0.2)

        addSubview(glassView)
        glassView.translatesAutoresizingMaskIntoConstraints = false
        glassView.contentView.addSubview(control)
        control.translatesAutoresizingMaskIntoConstraints = false

        let pad = Self.containerPadding
        NSLayoutConstraint.activate([
            glassView.leadingAnchor.constraint(equalTo: leadingAnchor),
            glassView.trailingAnchor.constraint(equalTo: trailingAnchor),
            glassView.topAnchor.constraint(equalTo: topAnchor),
            glassView.bottomAnchor.constraint(equalTo: bottomAnchor),

            control.leadingAnchor.constraint(equalTo: glassView.contentView.leadingAnchor, constant: pad),
            control.trailingAnchor.constraint(equalTo: glassView.contentView.trailingAnchor, constant: -pad),
            control.topAnchor.constraint(equalTo: glassView.contentView.topAnchor, constant: pad),
            control.bottomAnchor.constraint(equalTo: glassView.contentView.bottomAnchor, constant: -pad),
            control.heightAnchor.constraint(equalToConstant: Self.segmentHeight),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        glassView.layer.cornerRadius = bounds.height / 2
        glassView.layer.masksToBounds = true
    }
}


struct SwitcherView<Value: Hashable>: UIViewRepresentable {
    struct Item {
        let value: Value
        let image: UIImage
    }

    let items: [Item]
    @Binding var selection: Value

    static func totalWidth(for count: Int) -> CGFloat {
        GlassSwitcherContainer.segmentWidth * CGFloat(count) + GlassSwitcherContainer.containerPadding * 2
    }
    static var totalHeight: CGFloat { GlassSwitcherContainer.containerHeight }

    private static func transparentPlaceholder(size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            UIColor.clear.setFill()
            UIRectFill(CGRect(origin: .zero, size: size))
        }
    }
    func makeUIView(context: Context) -> GlassSwitcherContainer {
        let placeholders = items.map { _ in Self.transparentPlaceholder() }
        let control = GlassSegmentedControl(items: placeholders)
        for i in items.indices {
            control.setWidth(GlassSwitcherContainer.segmentWidth, forSegmentAt: i)
        }
        control.setIcons(items.map { $0.image })
        control.selectedSegmentIndex = items.firstIndex { $0.value == selection } ?? 0
        control.addTarget(context.coordinator, action: #selector(Coordinator.changed(_:)), for: .valueChanged)
        return GlassSwitcherContainer(control: control)
    }

    func updateUIView(_ uiView: GlassSwitcherContainer, context: Context) {
        context.coordinator.parent = self
        let index = items.firstIndex { $0.value == selection } ?? 0
        if uiView.control.selectedSegmentIndex != index {
            uiView.control.selectedSegmentIndex = index
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    @MainActor
    class Coordinator: NSObject {
        var parent: SwitcherView
        init(_ parent: SwitcherView) { self.parent = parent }
        @objc func changed(_ control: UISegmentedControl) {
            let i = control.selectedSegmentIndex
            if i >= 0, i < parent.items.count {
                parent.selection = parent.items[i].value
            }
        }
    }
}
