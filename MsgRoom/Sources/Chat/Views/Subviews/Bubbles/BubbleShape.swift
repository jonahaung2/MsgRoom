//
//  BubbleShape.swift
//  Conversation
//
//  Created by Aung Ko Min on 9/2/22.
//

import SwiftUI

struct BubbleShape: Shape, Comformable {
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

extension UIRectCorner: Comformable {
    public var id: UInt {
        rawValue
    }
    enum CodingKeys: CodingKey {
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
