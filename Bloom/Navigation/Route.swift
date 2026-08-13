//
//  Route.swift
//  Bloom
//
//  Created by Аскольд on 10.08.2026.
//

import SwiftUI

enum Route: Hashable, Identifiable {
    case chatList
    case chat(id: Int)
    
    var id: Self { self }
}

enum ModalRoute: Identifiable {
    case newMessage
    
    var id: Self { self }
}
