//
//  CustomBottomSheetContainerView.swift
//  Bloom
//
//  Created by Аскольд on 28.06.2026.
//

import SwiftUI

struct CustomBottomSheetContainerView<Content: View>: View {
    @Bindable var manager: BottomSheetManager
    let screenSize: CGSize
    @ViewBuilder let content: Content
    
    @State private var dragOffset: CGFloat = 0
    @State private var isDraggingSheet: Bool = false
    @State private var dragStartTranslation: CGFloat = 0
    
    private var collapsedHeight: CGFloat = 400
    private var expandedY: CGFloat { 0 }
    private var collapsedY: CGFloat { screenSize.height - collapsedHeight - 5 }
    private var hiddenY: CGFloat { screenSize.height + 20 }
    
    private var baseOffsetY: CGFloat {
        switch manager.state {
        case .hidden: return hiddenY
        case .collapsed: return collapsedY
        case .expanded: return expandedY
        }
    }
    
    private var currentY: CGFloat { baseOffsetY + dragOffset }
    
    private var progress: CGFloat {
        let totalDist = collapsedY - expandedY
        if totalDist == 0 { return 0 }
        let p = (collapsedY - currentY) / totalDist
        return min(max(p, 0.0), 1.0)
    }
    
    init(
           manager: BottomSheetManager,
           screenSize: CGSize,
           @ViewBuilder content: () -> Content
       ) {
           self.manager = manager
           self.screenSize = screenSize
           self.content = content()
       }
    
    var body: some View {
        let currentWidth = (screenSize.width - 10) + (10 * progress)
        let currentHeight = collapsedHeight + ((screenSize.height - collapsedHeight) * progress)
        let currentCornerRadius: CGFloat = 39
        
        VStack(spacing: 0) {
            DragHandleView()
                .frame(height: 30)
                .padding(.top, 8)
            
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: currentWidth, height: currentHeight, alignment: .top)
        .background(
            Color(.systemBackground)
        )
        .clipShape(RoundedRectangle(cornerRadius: currentCornerRadius))
        .offset(y: currentY)
        .scrollDisabled(manager.state == .collapsed || isDraggingSheet)
        .simultaneousGesture(dragGesture)
    }
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 5, coordinateSpace: .global)
            .onChanged { value in
                let y = value.translation.height
                
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
            }
            .onEnded { value in
                let y = value.translation.height
                let velocity = value.velocity.height
                
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
    }
}
