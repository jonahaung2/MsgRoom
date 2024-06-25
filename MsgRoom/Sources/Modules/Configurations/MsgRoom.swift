//
//  MsgRoom.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 25/6/24.
//

import SwiftUI
import SecureStorage
import XUI

struct MsgRoom {
    
    var storage = SecureStorage(suiteName: "group.jonahaung.msgRoom")!
    var incomingSocket = IncomingSocket()
    var outgoingSocket = OutgoingSocket()
    
    init() {
        if !storage.isKeyCreated {
            storage.password = UUID().uuidString
        }
    }
    
    func configure() {
        AppStateProviderKey.currentValue = Store(self)
    }
}

private struct AppStateProviderKey: InjectionKey {
    static var currentValue: Store<MsgRoom>?
}

extension InjectedValues {
    var msgRoom: Store<MsgRoom> {
        get {
            guard let injected = Self[AppStateProviderKey.self] else { fatalError("App was not setup") }
            return injected
        }
        set { Self[AppStateProviderKey.self] = newValue }
    }
    
    var storage: SecureStorage {
        get { msgRoom.value.storage }
        set { msgRoom.value.storage = newValue  }
    }
    var outgoingSocket: OutgoingSocket {
        get { msgRoom.value.outgoingSocket }
        set { msgRoom.value.outgoingSocket = newValue  }
    }
    var incomingSocket: IncomingSocket {
        get { msgRoom.value.incomingSocket }
        set { msgRoom.value.incomingSocket = newValue  }
    }
}
