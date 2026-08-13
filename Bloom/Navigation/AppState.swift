//
//  AppState.swift
//  Bloom
//
//  Created by Аскольд on 14.08.2026.
//

import SwiftUI

@Observable
final class AppState {
    enum Root {
        case auth
        case main
    }

    var root: Root

    init() {
        root = .auth
    }

    func authenticate() {
        withAnimation(.smooth(duration: 0.325)) {
            root = .main
        }
    }

    func logout() {
        withAnimation(.smooth(duration: 0.325)) {
            root = .auth
        }
    }
}
