//
//  View+ScrollBinding.swift
//  Bloom
//
//  Created by Аскольд on 28.06.2026.
//

import SwiftUI

extension View {
    func bindBottomSheetScrollOffset(to manager: BottomSheetManager) -> some View {
        self.onScrollGeometryChange(for: CGFloat.self) { geometry in
            geometry.contentOffset.y
        } action: { oldValue, newValue in
            manager.scrollOffset = newValue
        }
    }
}
