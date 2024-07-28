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
            withAnimation(.interpolatingSpring(duration: 0.5)) {
                scrollTo(item.id)
            }
        } else {
            scrollTo(item.id)
        }
    }
}

