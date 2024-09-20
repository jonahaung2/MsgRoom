//
//  ScrollViewPoroxy++.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 7/4/24.
//

import SwiftUI
import Models

public extension ScrollViewProxy {
    func scroll(to item: ScrollItem) {
        if item.animate {
            withAnimation(.spring(response: 0.4, dampingFraction: 1)) {
                scrollTo(item.id)
            }
        } else {
            scrollTo(item.id)
        }
    }
}

