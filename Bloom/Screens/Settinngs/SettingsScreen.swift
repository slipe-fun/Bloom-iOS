//
//  SettingsScreen.swift
//  Bloom
//
//  Created by Аскольд on 20.06.2026.
//

import SwiftUI
import BlurSwiftUI

struct SettingsScreen: View {
    @State private var scrollY: CGFloat = 0
    
    @Environment(AppRouter.self) private var router
    
    var body: some View {
        Button {
            router.isSettingsPresented = false
        } label: {
            Text("Back")
                .foregroundStyle(Theme.colors.primary)
        }
    }
}
