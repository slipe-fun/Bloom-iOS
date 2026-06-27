//
//  RowButtonStyle.swift
//  Bloom
//
//  Created by Аскольд on 20.06.2026.
//

import SwiftUI

struct RowButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Theme.colors.foreground : Color.clear)
            .contentShape(Rectangle())
            .animation(.smooth, value: configuration.isPressed)
    }
}

