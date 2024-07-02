//
//  ChatViewUpdates.swift
//  Msgr
//
//  Created by Aung Ko Min on 9/12/22.
//

import Foundation

public class ViewUpdater: ObservableObject {
    public typealias Work = () -> Void
    @Published public var blockOperations = [Work]()
    public func insert(_ block: @escaping Work) {
        blockOperations.append(block)
    }
    public func handleUpdates() {
        blockOperations.forEach { $0() }
        blockOperations.removeAll()
    }
    public init() { }
}
