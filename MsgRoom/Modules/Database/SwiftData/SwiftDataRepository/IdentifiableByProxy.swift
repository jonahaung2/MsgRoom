import Foundation

public protocol IdentifiableByProxy {
    associatedtype ProxID: Hashable

    var proxyID: ProxID { get }
}
