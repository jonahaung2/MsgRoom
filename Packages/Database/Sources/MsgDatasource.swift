//
//  MsgDatasourceProviding.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 8/7/24.
//

import Foundation
import Models

public protocol MsgDatasource {
    var room: Room { get set }
    @MainActor func loadInitialMsgs(for i: Int) -> [Msg]
    func loadMoreMsgsIfNeeded(for i: Int) -> [Msg]
    func didReceiveMsg(_ msg: Msg) async
}
