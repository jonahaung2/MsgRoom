//
//  DynamicOffset.swift
//
//
//  Created by Aung Ko Min on 4/7/24.
//

import SwiftUI

public enum InversedOffset: Hashable, Sendable, Identifiable {
    public var id: Self { self }
    case atTop, nearTop, center, nearCenter, nearBottom, atBottom, none
    var inversed: InversedOffset {
        switch self {
        case .atTop:
            return .atBottom
        case .nearTop:
            return .nearBottom
        case .nearCenter:
            return .nearCenter
        case .center:
            return .center
        case .nearBottom:
            return .nearTop
        case .atBottom:
            return .atTop
        case .none:
            return .none
        }
    }
}

public extension GeometryProxy {
    func parallaxOffsetInScrollView(_ length: Double = 1) -> Double {
        guard let scrollHeight = bounds(of: .scrollView)?.height else {
            return 0
        }
        let centerY = frame(in: .scrollView).midY
        let percent = ((centerY / scrollHeight) - 0.5) * 2
        let center = percent * -length
        return center
    }
    
    func scrollPosition(_ length: Double = 300) -> InversedOffset {
        guard let scrollHeight = bounds(of: .scrollView)?.height.rounded() else {
            return .none
        }
        return scrollPosition(length, scrollHeight: scrollHeight)
    }
    func scrollPosition(_ length: Double, scrollHeight: Double) -> InversedOffset {
        let frameInScrollView = frame(in: .scrollView(axis: .vertical))
        guard frameInScrollView.height > length else { return .none }
        
        let toCenterPosition = frameInScrollView.midY.rounded()
        let maxY = frameInScrollView.maxY.rounded()
        
        let toTopPosition = frameInScrollView.minY.rounded()
        let toBottomPosition =  scrollHeight - abs(maxY)
        let percent = (toCenterPosition / scrollHeight - 0.5) * 2
        let center = percent * -length
        let range = Int(-length)...Int(length)
        let isNearCenter = range.contains(Int(center))
        if isNearCenter {
            let isAtCenter = center == 0
            if isAtCenter {
                return .center
            }
            return .nearCenter
        }
        
        let nearTop = toTopPosition > -length
        let nearBottom = toBottomPosition > -length
        
        if nearTop || nearBottom {
            if nearTop && !nearBottom {
                let isAtTop = toTopPosition == 0
                if isAtTop {
                    return .atTop
                }
                return .nearTop
            } else if !nearTop && nearBottom {
                let isAtBottom = toBottomPosition == 0
                if isAtBottom {
                    return .atBottom
                }
                return .nearBottom
            }
        }
        
        return .none
    }
}
