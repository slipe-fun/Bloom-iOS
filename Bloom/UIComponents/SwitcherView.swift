//
//  SwitcherView.swift
//  Bloom
//
//  Created by Аскольд on 09.07.2026.
//

import SwiftUI

public struct SwitcherViewItem<Value: Hashable>: Equatable {
    public let value: Value
    public let image: Image
    
    public init(value: Value, image: Image) {
        self.value = value
        self.image = image
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.value == rhs.value
    }
}

public struct SwitcherView<Value: Hashable>: View {
    public let items: [SwitcherViewItem<Value>]
    @Binding public var selection: Value
    @State private var dragLocation: CGFloat? = nil
    
    private enum Constants {
        static var width: CGFloat { 77 }
        static var height: CGFloat { 47 }
        static var padding: CGFloat { 4 }
    }
    
    public init(items: [SwitcherViewItem<Value>], selection: Binding<Value>) {
        self.items = items
        self._selection = selection
    }
    
    public var body: some View {
        GlassEffectContainer {
            ZStack(alignment: .leading) {
                indicator
                segments
            }
            .contentShape(Capsule())
            .highPriorityGesture(dragGesture)
            .glassEffect(.clear.interactive().tint(Theme.colors.glassBackdrop))
        }
    }
    
    private var indicator: some View {
        Capsule()
            .fill(Theme.colors.text.opacity(0.15))
            .frame(width: Constants.width, height: Constants.height)
            .offset(x: indicatorOffset)
            .animation(.quickSpring, value: dragLocation != nil)
            .animation(dragLocation == nil ? .quickSpring : nil, value: indicatorOffset)
    }
    
    private var segments: some View {
        HStack(spacing: 0) {
            ForEach(items, id: \.value) { item in
                GlassSwitcherSegment(
                    item: item,
                    isSelected: !items.isEmpty && items[activeIndex].value == item.value,
                    segmentHeight: Constants.height,
                    segmentWidth: Constants.width
                )
                .equatable()
            }
        }
        .padding(Constants.padding)
    }
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                dragLocation = value.location.x
            }
            .onEnded { value in
                guard !items.isEmpty else { return }
                
                withAnimation(.quickSpring) {
                    selection = items[activeIndex].value
                    dragLocation = nil
                }
            }
    }
    
    private var indicatorOffset: CGFloat {
        let minX = Constants.padding
        
        guard let dragLocation else {
            return minX + CGFloat(selectedIndex) * Constants.width
        }
        
        let maxX = minX + CGFloat(max(0, items.count - 1)) * Constants.width
        let targetX = dragLocation - (Constants.width / 2)
        return min(max(targetX, minX), maxX)
    }
    
    private var activeIndex: Int {
        guard !items.isEmpty else { return 0 }
        
        if let dragLocation {
            let relativeX = dragLocation - Constants.padding - (Constants.width / 2)
            let index = Int(round(relativeX / Constants.width))
            return min(max(index, 0), items.count - 1)
        }
        
        return selectedIndex
    }
    
    private var selectedIndex: Int {
        items.firstIndex(where: { $0.value == selection }) ?? 0
    }
}

private struct GlassSwitcherSegment<Value: Hashable>: View, Equatable {
    let item: SwitcherViewItem<Value>
    let isSelected: Bool
    let segmentHeight: CGFloat
    let segmentWidth: CGFloat
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.item.value == rhs.item.value && lhs.isSelected == rhs.isSelected
    }
    
    var body: some View {
        item.image
            .resizable()
            .renderingMode(.template)
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            .foregroundStyle(Theme.colors.text)
            .opacity(isSelected ? 1.0 : 0.4)
            .animation(.quickSpring, value: isSelected)
            .frame(width: segmentWidth, height: segmentHeight)
    }
}
