//
//  MsgInteractions.swift
//  MsgRoomMain
//
//  Created by Aung Ko Min on 22/10/24.
//
import SwiftUI

public struct MsgCellInteraction {
    public typealias Action = (MsgCellInteractionTye) -> ()
    let action: Action
    func callAsFunction(_ data: MsgCellInteractionTye) {
        action(data)
    }
}
public struct MsgCellInteractionKey: @preconcurrency EnvironmentKey {
    @MainActor static public var defaultValue: MsgCellInteraction? = nil
}
public extension EnvironmentValues {
    var sendMsgCellInteraction: MsgCellInteraction? {
        get { self[MsgCellInteractionKey.self] }
        set { self[MsgCellInteractionKey.self] = newValue }
    }
}
public extension View {
    func receiveMsgCellInteraction(_ action: @escaping MsgCellInteraction.Action) -> some View {
        self.environment(\.sendMsgCellInteraction, MsgCellInteraction(action: action))
    }
}
