//
//  Date++.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 6/4/24.
//

import Foundation

extension Date {
    func getDifference(from start: Date, unit component: Calendar.Component) -> Int  {
        let dateComponents = Calendar.current.dateComponents([component], from: start, to: self)
        return dateComponents.second ?? 0
    }
}
