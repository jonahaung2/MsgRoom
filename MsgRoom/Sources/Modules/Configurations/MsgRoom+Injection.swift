//
//  MsgRoom+Injection.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 26/6/24.
//

import Foundation
import XUI
import SecureStorage
import SwiftData
import MsgRoomCore

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
    var storage: SecureStorage {
        get { msgRoom.value.secureStorage }
        set { msgRoom.value.secureStorage = newValue  }
    }
    var outgoingSocket: OutgoingSocket {
        get { msgRoom.value.outgoingSocket }
        set { msgRoom.value.outgoingSocket = newValue  }
    }
    var incomingSocket: IncomingSocket {
        get { msgRoom.value.incomingSocket }
        set { msgRoom.value.incomingSocket = newValue  }
    }
    var coreDataContainer: CoreDataContainer {
        get { msgRoom.value.coreDataContainer }
        set { msgRoom.value.coreDataContainer = newValue  }
    }
    var coreDataStore: CoreDataStore {
        get { msgRoom.value.coreDataStore }
        set { msgRoom.value.coreDataStore = newValue  }
    }
    var swiftDatabase: DataModel {
        get { msgRoom.value.dataModel }
        set { msgRoom.value.dataModel = newValue  }
    }
}
