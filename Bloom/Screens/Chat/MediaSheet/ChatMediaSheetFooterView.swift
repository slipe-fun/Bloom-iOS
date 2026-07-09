//
//  ChatMediaSheetFooterView.swift
//  Bloom
//
//  Created by Аскольд on 08.07.2026.
//

import SwiftUI

enum Mode: Hashable { case image, document }

struct ChatMediaSheetFooterView: View {
    @State private var mode: Mode = .image
    
    
    private let items: [SwitcherView<Mode>.Item] = [
        .init(value: .image, image: UIImage(named: "image_icon")!),
        .init(value: .document, image: UIImage(named: "file_icon")!),
    ]
    
    var body: some View {
        HStack {
            SwitcherView(
                items: items,
                selection: $mode
            )
                    .frame(
                        width: SwitcherView<Mode>.totalWidth(for: items.count),
                           height: SwitcherView<Mode>.totalHeight
                    )
        }
        .frame(maxWidth: .infinity)
        .padding(.top, Theme.spacing.md)
        .padding(.horizontal, Theme.spacing.xxxl)
        .padding(.bottom, Theme.spacing.xxxl)
        .bottomGradientBackground(color: Theme.colors.sectionForeground)
    }
}

