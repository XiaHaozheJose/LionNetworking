import Foundation
import Network

#if os(iOS)
@available(iOS 12, *)
public class LionNetworkMonitor {
    
    public static let shared = LionNetworkMonitor()

    private let monitor: NWPathMonitor
    private let queue: DispatchQueue
    
    public var isConnected: Bool {
        return monitor.currentPath.status == .satisfied
    }
    
    public var connectionType: ConnectionType {
        let connection = monitor.currentPath
        if connection.usesInterfaceType(.wifi) {
            return .wifi
        } else if connection.usesInterfaceType(.cellular) {
            return .cellular
        } else if connection.usesInterfaceType(.wiredEthernet) {
            return .wiredEthernet
        } else {
            return .unknown
        }
    }
    
    public enum ConnectionType {
        case wifi
        case cellular
        case wiredEthernet
        case unknown
    }
    
    private init() {
        monitor = NWPathMonitor()
        queue = DispatchQueue(label: "LionNetworkMonitor")
        
        monitor.pathUpdateHandler = { _ in
            NotificationCenter.default.post(name: .lionNetworkStatusChanged, object: nil)
        }
        
        monitor.start(queue: queue)
    }
}

extension Notification.Name {
    public static let lionNetworkStatusChanged = Notification.Name("lionNetworkStatusChanged")
}
#endif
