//
//  BloomApp.swift
//  Bloom
//
//  Created by Аскольд on 10.08.2026.
//

import SwiftUI

@main
struct BloomApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
        }
    }
}
