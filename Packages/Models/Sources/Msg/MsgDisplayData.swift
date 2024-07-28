//
//  MsgDisplayData.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/7/24.
//

import Foundation

public struct MsgDisplayData: Sendable {
    public let id: Int
    public let msg: Msg
    public let style: MsgCellLayout
    public init(id: Int, msg: Msg, style: MsgCellLayout) {
        self.id = id
        self.msg = msg
        self.style = style
    }
}
