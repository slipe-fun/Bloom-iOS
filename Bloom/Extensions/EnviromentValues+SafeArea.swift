//
//  EnviromentValues+SafeArea.swift
//  Bloom
//
//  Created by Аскольд on 20.06.2026.
//

import SwiftUI

struct CustomSafeAreaKey: EnvironmentKey {
    static var defaultValue: EdgeInsets = EdgeInsets()
}

extension EnvironmentValues {
    var customSafeArea: EdgeInsets {
        get { self[CustomSafeAreaKey.self] }
        set { self[CustomSafeAreaKey.self] = newValue }
    }
}
