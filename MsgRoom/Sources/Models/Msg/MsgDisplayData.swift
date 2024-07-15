//
//  MsgDisplayData.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 12/7/24.
//

import Foundation

public struct MsgDisplayData: Sendable {
    let id: Int
    let msg: Msg
    let style: MsgCellLayout
}
