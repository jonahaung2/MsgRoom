//
//  MsgDatasourceProviding.swift
//  MsgRoom
//
//  Created by Aung Ko Min on 8/7/24.
//

import Foundation
public protocol MsgDatasourceProviding {
    var room: any RoomRepresentable { get set }
    var pageSize: Int { get }
    func fetchInitialMsgs<T>(for i: Int) -> [T] where T: MsgRepresentable
    func loadMoreMsgsIfNeeded<T>(for i: Int) -> [T] where T: MsgRepresentable
    func didReceiveMsg<T>(_ msg: T)
    func getFirstMsg<T>() -> T? where T: MsgRepresentable
}
