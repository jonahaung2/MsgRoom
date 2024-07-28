//
//  BubbleShape.swift
//  Conversation
//
//  Created by Aung Ko Min on 9/2/22.
//

import SwiftUI
import Models
import UIKit

public struct BubbleShape: Shape, Conformable {
    public var id: BubbleShape { self }
    public let corners: UIRectCorner
    public let cornorRadius: CGFloat
    
    public init(corners: UIRectCorner, cornorRadius: CGFloat) {
        self.corners = corners
        self.cornorRadius = cornorRadius
    }
    public func path(in rect: CGRect) -> Path {
        Path(UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: cornorRadius/1.3, height: cornorRadius)).cgPath)
    }
    public func hash(into hasher: inout Hasher) {
        corners.rawValue.hash(into: &hasher)
        cornorRadius.hash(into: &hasher)
    }
}

extension UIRectCorner: Conformable {
    public var id: UInt {
        rawValue
    }
    public enum CodingKeys: CodingKey {
        case rawValue
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawValue = try container.decode(UInt.self, forKey: .rawValue)
        self.init(rawValue: rawValue)
    }
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.rawValue, forKey: .rawValue)
    }
}
