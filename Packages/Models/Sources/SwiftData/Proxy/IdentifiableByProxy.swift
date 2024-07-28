//
//  File.swift
//  
//
//  Created by Aung Ko Min on 17/7/24.
//

import Foundation
public protocol IdentifiableByProxy {
    associatedtype ProxID: Hashable
    var id: ProxID { get }
}
