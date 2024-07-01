//
//  DraggableModifier.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 8/4/24.
//

import SwiftUI
import XUI

struct DraggableModifier : ViewModifier {
    enum Direction {
        case left, right, top, bottom
        var isVertical: Bool { self == .top || self == .bottom }
        var isHorizontal: Bool { self == .left || self == .right }
        
        func offset(for draggableOffset: CGSize) -> CGSize {
            let width = self.isVertical ? 0 : (self == .left ? min(0, min(draggableOffset.width, 150)) : max(0, min(draggableOffset.width, 150)))
            let height = self.isHorizontal ? 0 : (self == .top ? max(0, draggableOffset.height) : min(0, draggableOffset.height))
            return .init(width: width, height: height)
        }
    }
    
    let direction: Direction
    @State private var draggedOffset: CGSize = .zero
    
    func body(content: Content) -> some View {
        content
            .offset(draggedOffset)
            .gesture(
                DragGesture(minimumDistance: 30)
                    .onChanged { value in
                        let offset = direction.offset(for: value.translation)
                        self.draggedOffset = offset
                    }
                    .onEnded { value in
                        if draggedOffset.width != 0 {
                            _Haptics.play(.rigid)
                        }
                        draggedOffset.width = 0
                    }
            )
    }
}

