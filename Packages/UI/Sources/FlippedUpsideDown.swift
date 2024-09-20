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

public extension UIColor {
    func image(_ size: CGSize = CGSize(width: 2, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
