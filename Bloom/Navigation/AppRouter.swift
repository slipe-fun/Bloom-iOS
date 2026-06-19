//
//  AppRouter.swift
//  Bloom
//
//  Created by Аскольд on 20.06.2026.
//

import SwiftUI

@Observable
class AppRouter {
    
    var path: [AppRoute] = []
    
    var isSettingsPresented: Bool = false
    
    var sheet: AppRoute?
    
    func push(_ route: AppRoute) {
        path.append(route)
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        path.removeAll()
    }
}
