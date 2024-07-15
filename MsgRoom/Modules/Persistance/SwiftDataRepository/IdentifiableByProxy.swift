import Foundation

public protocol IdentifiableByProxy {
    associatedtype ProxID: Hashable

    var id: ProxID { get }
}
