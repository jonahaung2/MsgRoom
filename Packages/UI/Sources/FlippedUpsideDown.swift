//
//  FlippedUpsideDown.swift
//  MsgRoom
//
//  Create d by Aung Ko Min on 7/4/24.
//

import SwiftUI
private struct FlippedUpsideDown: ViewModifier {
    func body(content: Content) -> some View {
        content
            .rotationEffect(.radians(Double.pi))
            .scaleEffect(x: -1, y: 1, anchor: .center)
    }
}

public extension View {
    func flippedUpsideDown() -> some View {
        modifier(FlippedUpsideDown())
    }
}
