//
//  AppRouter.swift
//  Bloom
//
//  Created by Аскольд on 20.06.2026.
//

import SwiftUI
import Observation

@Observable
@MainActor
class AppRouter {
    var path: [AppRoute] = []
    
    var isAuthenticated: Bool {
        didSet {
            UserDefaults.standard.set(isAuthenticated, forKey: "isAuthenticated")
        }
    }
    
    init() {
        self.isAuthenticated = UserDefaults.standard.bool(forKey: "isAuthenticated")
        
        Task {
            _ = HapticManager.shared
        }
    }
    
    var isSettingsPresented: Bool {
        get { path.contains(.settings) }
        set {
            if newValue && !path.contains(.settings) {
                push(.settings)
            } else if !newValue && path.last == .settings {
                pop()
            }
        }
    }
    
    
    var standardPath: [AppRoute] {
        path.filter { $0 != .settings }
    }
    
    var isSettingsTop: Bool {
        path.last == .settings
    }
    
    
    func setAuthenticated(_ authenticated: Bool) {
        withAnimation(.quickSpring) {
            self.isAuthenticated = authenticated
            if !authenticated {
                self.path.removeAll()
            }
        }
    }
    
    func push(_ route: AppRoute) {
        withAnimation(.normalSpring) {
            path.append(route)
        
            if route == .settings {
                HapticManager.shared.triggerSettingsOpeningHaptic()
            }
        }
    }
    
    func pop(animated: Bool = true) {
        if animated {
            withAnimation(.normalSpring) {
                if !path.isEmpty {
                    path.removeLast()
                }
            }
        } else {
            if !path.isEmpty {
                path.removeLast()
            }
        }
    }
    
    func popToRoot() {
        withAnimation(.normalSpring) {
            path.removeAll()
        }
    }
}
