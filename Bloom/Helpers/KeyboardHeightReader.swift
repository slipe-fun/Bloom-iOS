//
//  KeyboardHeightReader.swift
//  Bloom
//
//  Created by Аскольд on 24.06.2026.
//

import SwiftUI

struct KeyboardAttachedBar<Content: View>: UIViewControllerRepresentable {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()

        let host = UIHostingController(rootView: content)

        host.view.translatesAutoresizingMaskIntoConstraints = false
        host.view.backgroundColor = .clear

        vc.addChild(host)
        vc.view.addSubview(host.view)

        NSLayoutConstraint.activate([
            host.view.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor),
            host.view.bottomAnchor.constraint(
                equalTo: vc.view.keyboardLayoutGuide.topAnchor
            )
        ])

        host.didMove(toParent: vc)

        return vc
    }

    func updateUIViewController(
        _ uiViewController: UIViewController,
        context: Context
    ) {}
}
