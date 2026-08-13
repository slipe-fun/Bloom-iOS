//
//  Router.swift
//  Bloom
//
//  Created by Аскольд on 10.08.2026.
//

import SwiftUI

@Observable
final class Router {
    var path = NavigationPath()
    var presentedSheet: ModalRoute?
    private var pendingRoute: Route?
    
    func push(_ route: Route) { path.append(route) }
    func pop() { if !path.isEmpty { path.removeLast() } }
    
    func presentModal(_ route: ModalRoute) { presentedSheet = route }
    func dismissModal() { presentedSheet = nil }
    
    func selectChat(id: Int) {
        pendingRoute = .chat(id: id)
        presentedSheet = nil
    }

    func pushPendingRouteIfNeeded() {
        if let route = pendingRoute {
            path.append(route)
            pendingRoute = nil
        }
    }
    
}
