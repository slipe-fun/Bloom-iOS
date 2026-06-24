//
//  AppRouter.swift
//  Bloom
//
//  Created by Аскольд on 20.06.2026.
//

import SwiftUI
import Observation

@Observable
class AppRouter {
    var path: [AppRoute] = []
    
    var isAuthenticated: Bool {
        didSet {
            UserDefaults.standard.set(isAuthenticated, forKey: "isAuthenticated")
        }
    }
    
    init() {
        self.isAuthenticated = UserDefaults.standard.bool(forKey: "isAuthenticated")
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
        }
    }
    
    func pop() {
        withAnimation(.normalSpring) {
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
