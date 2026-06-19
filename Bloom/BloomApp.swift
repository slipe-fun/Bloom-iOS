//
//  BloomApp.swift
//  Bloom
//
//  Created by Аскольд on 19.06.2026.
//

import SwiftUI

@main
struct BloomApp: App {
    var body: some Scene {
        WindowGroup {
            ZStack {
                Theme.colors.background
                    .ignoresSafeArea()
                
                Text("Bloom SwiftUI")
                    .font(Theme.font.bold(size: Theme.fontSize.xxl))
                    .foregroundStyle(Theme.colors.text)
            }
        }
    }
}
