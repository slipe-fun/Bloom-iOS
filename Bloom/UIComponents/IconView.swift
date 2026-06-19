//
//  IconView.swift
//  Bloom
//
//  Created by Аскольд on 19.06.2026.
//

import SwiftUI

struct IconView: View {
    let name: String
    var size: CGFloat = 24
    var color: Color = Theme.colors.text
    
    var body: some View {
        Image(name)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .foregroundStyle(color)
    }
}
