//
//  ChatMediaSheetFooterView.swift
//  Bloom
//
//  Created by Аскольд on 08.07.2026.
//

import SwiftUI

public enum FooterTab: Hashable {
    case gallery
    case files
    case camera
}

struct ChatMediaSheetFooterView: View {
    @State private var selectedTab: FooterTab = .gallery
    
    
    private let items: [SwitcherViewItem<FooterTab>] = [
        .init(value: .gallery, image: Image("image_icon")),
        .init(value: .files, image: Image("file_icon")),
        .init(value: .camera, image: Image("camera_icon"))
    ]
    
    var body: some View {
        HStack {
           SwitcherView(
                items: items,
                selection: $selectedTab
           )
        }
        .frame(maxWidth: .infinity)
        .padding(.top, Theme.spacing.md)
        .padding(.horizontal, Theme.spacing.xxxl)
        .padding(.bottom, Theme.spacing.xxxl)
        .bottomGradientBackground(color: Theme.colors.sectionForeground)
    }
}

