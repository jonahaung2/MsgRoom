//
//  BubbleShape.swift
//  Conversation
//
//  Created by Aung Ko Min on 9/2/22.
//

import SwiftUI

struct BubbleShape: Shape, Hashable, Identifiable, Sendable{
    var id: BubbleShape { self }
    let corners: UIRectCorner
    let cornorRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        Path(UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: cornorRadius, height: cornorRadius)).cgPath)
    }
    func hash(into hasher: inout Hasher) {
        corners.rawValue.hash(into: &hasher)
        cornorRadius.hash(into: &hasher)
    }
}

