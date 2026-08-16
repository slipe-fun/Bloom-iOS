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
    @State private var bloomManager = BloomManager()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
                .environment(bloomManager)
                // test test test (delete later)
                .onChange(of: bloomManager.currentUser?.id, initial: true) { oldValue, newValue in
                    if let userID = newValue {
                        print(userID)
                    } else {
                        print("no active session")
                    }
                }
        }
    }
}
