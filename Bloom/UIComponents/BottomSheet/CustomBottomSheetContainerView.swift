//
//  CustomBottomSheetContainerView.swift
//  Bloom
//
//  Created by Аскольд on 28.06.2026.
//

import SwiftUI

struct BottomSheetVisuals<Content: View>: View, Animatable {
    var currentY: CGFloat
    let expandedY: CGFloat
    let collapsedY: CGFloat
    let collapsedHeight: CGFloat
    let sheetSpace: CGFloat
    let screenSize: CGSize
    let safeAreaInsets: EdgeInsets
    let sheetTopRadius: CGFloat
    let content: Content
    
    var animatableData: CGFloat {
        get { currentY }
        set { currentY = newValue }
    }
    
    var body: some View {
        let totalDist = collapsedY - expandedY
        let p: CGFloat = totalDist == 0 ? 0 : min(max((collapsedY - currentY) / totalDist, 0.0), 1.0)
        
        let expandedHeight = screenSize.height - expandedY
        let currentVisualHeight = collapsedHeight + ((expandedHeight - collapsedHeight) * p)
        let minScale = 1.0 - ((sheetSpace * 2) / screenSize.width)
        let currentScale = minScale + ((1.0 - minScale) * p)
        let compensatedHeight = currentVisualHeight / currentScale
        
        let currentRadius: CGFloat = p >= 0.999 ? 0 : safeAreaInsets.top - 4 - (sheetSpace / 2)
        
        VStack(spacing: 0) {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: screenSize.width, height: compensatedHeight, alignment: .top)
        .background(Theme.colors.sectionForeground)
        .scrollIndicators(.hidden)
        .clipShape(
            UnevenRoundedRectangle(
                cornerRadii: .init(
                    topLeading: sheetTopRadius,
                    bottomLeading: currentRadius,
                    bottomTrailing: currentRadius,
                    topTrailing: sheetTopRadius
                )
            )
        )
        .animation(nil, value: currentRadius)
        .scaleEffect(currentScale, anchor: .top)
        .offset(y: currentY)
    }
}

struct CustomBottomSheetContainerView<Content: View>: View {
    @Bindable var manager: BottomSheetManager
    let screenSize: CGSize
    let safeAreaInsets: EdgeInsets
    @ViewBuilder let content: Content
    
    @State private var dragOffset: CGFloat = 0
    @State private var isDraggingSheet: Bool = false
    @State private var dragStartTranslation: CGFloat = 0
    
    private let collapsedHeight: CGFloat = 475
    private let sheetSpace: CGFloat = 8
    private let sheetTopRadius: CGFloat = 40
    
    private var expandedY: CGFloat { safeAreaInsets.top + Theme.spacing.md }
    private var collapsedY: CGFloat { screenSize.height - collapsedHeight - sheetSpace }
    private var hiddenY: CGFloat { screenSize.height + Theme.spacing.xxxl }
    
    private var baseOffsetY: CGFloat {
        switch manager.state {
        case .hidden: return hiddenY
        case .collapsed: return collapsedY
        case .expanded: return expandedY
        }
    }
    
    private var currentY: CGFloat {
        max(expandedY, baseOffsetY + dragOffset)
    }
    
    init(
        manager: BottomSheetManager,
        screenSize: CGSize,
        safeAreaInsets: EdgeInsets,
        @ViewBuilder content: () -> Content
    ) {
        self.manager = manager
        self.screenSize = screenSize
        self.safeAreaInsets = safeAreaInsets
        self.content = content()
    }
    
    var body: some View {
        BottomSheetVisuals(
            currentY: currentY,
            expandedY: expandedY,
            collapsedY: collapsedY,
            collapsedHeight: collapsedHeight,
            sheetSpace: sheetSpace,
            screenSize: screenSize,
            safeAreaInsets: safeAreaInsets,
            sheetTopRadius: sheetTopRadius,
            content: content
        )
        .scrollDisabled(manager.state == .collapsed || isDraggingSheet)
        .gesture(panGesture)
    }
    
    private var panGesture: some UIGestureRecognizerRepresentable {
        CustomPanGesture(
            onChanged: { recognizer in
                let y = recognizer.translation(in: nil).y
                
                if manager.state == .expanded {
                    if y < 0 {
                        isDraggingSheet = false
                        dragOffset = 0
                    } else if y > 0 {
                        if manager.scrollOffset <= 0 {
                            if !isDraggingSheet {
                                isDraggingSheet = true
                                dragStartTranslation = y
                            }
                            dragOffset = y - dragStartTranslation
                        } else {
                            isDraggingSheet = false
                        }
                    }
                } else if manager.state == .collapsed {
                    isDraggingSheet = true
                    if y > 0 {
                        dragOffset = y * 0.3
                    } else {
                        dragOffset = y
                    }
                }
            },
            onEnded: { recognizer in
                let y = recognizer.translation(in: nil).y
                let velocity = recognizer.velocity(in: nil).y
                
                if manager.state == .collapsed {
                    withAnimation(.normalSpring) {
                        if y < -50 || velocity < -300 {
                            manager.state = .expanded
                        } else if y > 50 || velocity > 300 {
                            manager.dismiss()
                        }
                        dragOffset = 0
                    }
                } else if manager.state == .expanded {
                    if isDraggingSheet {
                        let actualDrag = y - dragStartTranslation
                        withAnimation(.normalSpring) {
                            if actualDrag > 100 || velocity > 300 {
                                manager.state = .collapsed
                            }
                            dragOffset = 0
                        }
                    }
                }
                
                isDraggingSheet = false
                dragStartTranslation = 0
            }
        )
    }
}
