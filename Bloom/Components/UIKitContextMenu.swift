//
//  UIKitContextMenu.swift
//  Bloom
//
//  Created by Аскольд on 13.08.2026.
//

import SwiftUI
import UIKit

struct ContextMenuAction {
    let title: String
    let systemImage: String?
    let isDestructive: Bool
    let isDisabled: Bool
    let handler: () -> Void

    init(
        title: String,
        systemImage: String? = nil,
        isDestructive: Bool = false,
        isDisabled: Bool = false,
        handler: @escaping () -> Void
    ) {
        self.title = title
        self.systemImage = systemImage
        self.isDestructive = isDestructive
        self.isDisabled = isDisabled
        self.handler = handler
    }
}

private struct UIKitContextMenuView<Preview: View>: UIViewRepresentable {
    let actions: [ContextMenuAction]
    let preview: Preview
    let previewSize: CGSize
    let cornerRadius: CGFloat
    @Binding var isMenuPresented: Bool

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        let interaction = UIContextMenuInteraction(delegate: context.coordinator)
        view.addInteraction(interaction)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        context.coordinator.actions = actions
        context.coordinator.preview = AnyView(preview)
        context.coordinator.previewSize = previewSize
        context.coordinator.cornerRadius = cornerRadius
        context.coordinator.isMenuPresented = $isMenuPresented
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(
            actions: actions,
            preview: AnyView(preview),
            previewSize: previewSize,
            cornerRadius: cornerRadius,
            isMenuPresented: $isMenuPresented
        )
    }

    final class Coordinator: NSObject, UIContextMenuInteractionDelegate {
        var actions: [ContextMenuAction]
        var preview: AnyView
        var previewSize: CGSize
        var cornerRadius: CGFloat
        var isMenuPresented: Binding<Bool>

        init(
            actions: [ContextMenuAction],
            preview: AnyView,
            previewSize: CGSize,
            cornerRadius: CGFloat,
            isMenuPresented: Binding<Bool>
        ) {
            self.actions = actions
            self.preview = preview
            self.previewSize = previewSize
            self.cornerRadius = cornerRadius
            self.isMenuPresented = isMenuPresented
        }

        func contextMenuInteraction(
            _ interaction: UIContextMenuInteraction,
            configurationForMenuAtLocation location: CGPoint
        ) -> UIContextMenuConfiguration? {
            guard previewSize.width > 0, previewSize.height > 0 else { return nil }

            return UIContextMenuConfiguration(
                identifier: nil,
                previewProvider: { [preview, previewSize] in
                    let hosting = UIHostingController(rootView: preview)
                    hosting.view.backgroundColor = .clear
                    hosting.preferredContentSize = previewSize
                    return hosting
                },
                actionProvider: { [actions] _ in
                    let menuActions = actions.map { action in
                        var attributes: UIMenuElement.Attributes = []
                        if action.isDestructive { attributes.insert(.destructive) }
                        if action.isDisabled { attributes.insert(.disabled) }

                        return UIAction(
                            title: action.title,
                            image: action.systemImage.flatMap { UIImage(systemName: $0) },
                            attributes: attributes
                        ) { _ in
                            action.handler()
                        }
                    }
                    return UIMenu(title: "", children: menuActions)
                }
            )
        }

        func contextMenuInteraction(
            _ interaction: UIContextMenuInteraction,
            willDisplayMenuFor configuration: UIContextMenuConfiguration,
            animator: UIContextMenuInteractionAnimating?
        ) {
            animator?.addAnimations {
                self.isMenuPresented.wrappedValue = true
            }
        }

        func contextMenuInteraction(
            _ interaction: UIContextMenuInteraction,
            willEndFor configuration: UIContextMenuConfiguration,
            animator: UIContextMenuInteractionAnimating?
        ) {
            animator?.addAnimations {
                self.isMenuPresented.wrappedValue = false
            }
        }

        func contextMenuInteraction(
            _ interaction: UIContextMenuInteraction,
            previewForHighlightingMenuWithConfiguration configuration: UIContextMenuConfiguration
        ) -> UITargetedPreview? {
            makeTargetedPreview(for: interaction)
        }

        func contextMenuInteraction(
            _ interaction: UIContextMenuInteraction,
            previewForDismissingMenuWithConfiguration configuration: UIContextMenuConfiguration
        ) -> UITargetedPreview? {
            makeTargetedPreview(for: interaction)
        }

        private func makeTargetedPreview(for interaction: UIContextMenuInteraction) -> UITargetedPreview? {
            guard let interactionView = interaction.view,
                  let window = interactionView.window,
                  previewSize.width > 0, previewSize.height > 0 else {
                return nil
            }

            let hosting = UIHostingController(
                rootView: preview.frame(width: previewSize.width, height: previewSize.height)
            )
            hosting.view.backgroundColor = .clear
            hosting.view.bounds = CGRect(origin: .zero, size: previewSize)
            hosting.view.layoutIfNeeded()

            let parameters = UIPreviewParameters()
            parameters.backgroundColor = .clear
            parameters.visiblePath = UIBezierPath(
                roundedRect: CGRect(origin: .zero, size: previewSize),
                cornerRadius: cornerRadius
            )

            let centerInWindow = interactionView.convert(
                CGPoint(x: interactionView.bounds.midX, y: interactionView.bounds.midY),
                to: window
            )

            let target = UIPreviewTarget(container: window, center: centerInWindow)
            return UITargetedPreview(view: hosting.view, parameters: parameters, target: target)
        }
    }
}


private struct UIKitContextMenuModifier<Preview: View>: ViewModifier {
    let actions: [ContextMenuAction]
    let cornerRadius: CGFloat
    let preview: () -> Preview

    @State private var previewSize: CGSize = .zero
    @State private var isMenuPresented = false

    func body(content: Content) -> some View {
        content
            .opacity(isMenuPresented ? 0 : 1)
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear { previewSize = geo.size }
                        .onChange(of: geo.size) { _, newSize in previewSize = newSize }
                }
            )
            .overlay(
                UIKitContextMenuView(
                    actions: actions,
                    preview: preview(),
                    previewSize: previewSize,
                    cornerRadius: cornerRadius,
                    isMenuPresented: $isMenuPresented
                )
            )
    }
}

extension View {
    func uiKitContextMenu<Preview: View>(
        cornerRadius: CGFloat = 22,
        actions: [ContextMenuAction],
        @ViewBuilder preview: @escaping () -> Preview
    ) -> some View {
        self.modifier(
            UIKitContextMenuModifier(
                actions: actions,
                cornerRadius: cornerRadius,
                preview: preview
            )
        )
    }
}
