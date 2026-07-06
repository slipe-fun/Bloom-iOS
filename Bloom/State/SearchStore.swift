//
//  SearchStore.swift
//  Bloom
//
//  Created by Аскольд on 27.06.2026.
//

import SwiftUI
import Observation

@Observable
final class SearchStore {
    var search: Bool = false
    var searchValue: String = ""
    
    @MainActor
    func setSearch(_ isActive: Bool) {
        withAnimation(.normalSpring) {
            self.search = isActive
        }
    }
    
    @MainActor
    func clearSearch() {
        self.searchValue = ""
        setSearch(false)
    }
}
