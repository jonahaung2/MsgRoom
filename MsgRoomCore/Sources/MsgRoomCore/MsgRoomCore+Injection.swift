//
//  File.swift
//  
//
//  Created by Aung Ko Min on 2/7/24.
//

import Foundation
import XUI

extension MsgRoomCore {
    public func configure() {
        AppStateProviderKey.currentValue = Store(self)
    }
}

private struct AppStateProviderKey: InjectionKey {
    static var currentValue: Store<MsgRoomCore>?
}

extension InjectedValues {
    var msgRoom: Store<MsgRoomCore> {
        get {
            guard let injected = Self[AppStateProviderKey.self] else { fatalError("App was not setup") }
            return injected
        }
        set { Self[AppStateProviderKey.self] = newValue }
    }
    var incomingSocket: IncomingSocket {
        get { msgRoom.value.incomingSocket }
        set { msgRoom.value.incomingSocket = newValue  }
    }
    var outgoingSocket: OutgoingSocket {
        get { msgRoom.value.outgoingSocket }
        set { msgRoom.value.outgoingSocket = newValue  }
    }
}
