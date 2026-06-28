//
//  DragHandleView.swift
//  Bloom
//
//  Created by Аскольд on 28.06.2026.
//

import SwiftUI

struct DragHandleView: View {
    var body: some View {
        Capsule()
            .fill(Color.secondary.opacity(0.35))
            .frame(width: 38, height: 5)
            .padding(.top, 10)
            .padding(.bottom, 10)
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
            .contentShape(Rectangle())
    }
}
