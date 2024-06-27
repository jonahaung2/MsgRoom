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
    var contacts: PhoneContacts {
        get { msgRoom.value.phoneContacts }
        set { msgRoom.value.phoneContacts = newValue  }
    }
    var coreDataStack: CoreDataStack {
        get { msgRoom.value.coreDataStack }
        set { msgRoom.value.coreDataStack = newValue  }
    }
    var coreDataStore: CoreDataStore {
        get { msgRoom.value.coreDataStore }
        set { msgRoom.value.coreDataStore = newValue  }
    }
}
