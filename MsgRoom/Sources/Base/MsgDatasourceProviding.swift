//
//  MsgDatasourceProviding.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 8/7/24.
//

import Foundation
protocol MsgDatasourceProviding {
    var room: Room { get set }
    func loadMoreMsgsIfNeeded(for i: Int) -> [Msg]
    func didReceiveMsg(_ msg: Msg) async
}
