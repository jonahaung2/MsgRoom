//
//  MsgRoom+Injection.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 26/6/24.
//

import Foundation
import XUI
import SwiftData

extension MsgRoom {
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
    
    var swiftdataRepo: SwiftDataRepository {
        get { msgRoom.value.swiftdataRepo }
        set { msgRoom.value.swiftdataRepo = newValue  }
    }
    var swiftDatabase: SwiftDataStore {
        get { msgRoom.value.dataModel }
        set { msgRoom.value.dataModel = newValue  }
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
