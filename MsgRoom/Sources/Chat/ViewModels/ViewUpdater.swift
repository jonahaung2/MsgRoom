//
//  ChatViewUpdates.swift
//  Msgr
//
//  Created by Aung Ko Min on 9/12/22.
//

import Foundation

class ViewUpdater: ObservableObject {

    typealias Work = () -> Void

    @Published var blockOperations = [Work]()

    func insert(_ block: @escaping Work) {
        blockOperations.append(block)
    }
    
    func handleUpdates() {
        blockOperations.forEach { $0() }
        blockOperations.removeAll()
    }
}
