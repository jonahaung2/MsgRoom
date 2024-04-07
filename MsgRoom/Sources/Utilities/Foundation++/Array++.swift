//
//  Array++.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 7/4/24.
//

import Foundation
extension Array {
    func slice(size: Int) -> [[Element]] {
        (0...(count / size)).map{Array(self[($0 * size)..<(Swift.min($0 * size + size, count))])}
    }
}
