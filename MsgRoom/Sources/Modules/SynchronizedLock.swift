//
//  SynchronizedLock.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 27/6/24.
//

import Foundation

@propertyWrapper
public struct SynchronizedLock<Value> {
    private var value: Value
    private var lock = NSLock()
    
    public var wrappedValue: Value {
        get { lock.synchronized { value } }
        set { lock.synchronized { value = newValue } }
    }
    public init(wrappedValue value: Value) {
        self.value = value
    }
}

private extension NSLock {
    
    @discardableResult
    func synchronized<T>(_ block: () -> T) -> T {
        lock()
        defer { unlock() }
        return block()
    }
}
