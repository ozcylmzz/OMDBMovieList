//
//  ReachabilityManager.swift
//  OMDBMovieList
//
//  Created by özcan yılmaz on 12.09.2023.
//

import Foundation
import Network

public protocol NetworkStatusListener: AnyObject {
    func networkStatusDidChange(status: NWPath.Status)
}

class ReachabilityManager {
    
    static let shared = ReachabilityManager()
    
    private var listeners = [NetworkStatusListener]()
    
    var isNetworkAvailable: Bool {
        return currentNetworkStatus != .unsatisfied
    }
    
    private var currentNetworkStatus: NWPath.Status?
    
    private let monitor = NWPathMonitor()
    
    private init() {
        startMonitoring()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.currentNetworkStatus = self?.getPathStatus(status: path.status) ?? .unsatisfied
            self?.notifyListeners(status: self?.getPathStatus(status: path.status) ?? .unsatisfied)
        }
        let queue = DispatchQueue(label: networkMonitor)
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
    func getPathStatus(status: NWPath.Status) -> NWPath.Status {
        switch status {
            
        case .satisfied:
            return .unsatisfied
        case .unsatisfied:
            return .satisfied
        case .requiresConnection:
            return .requiresConnection
        @unknown default:
            return .unsatisfied
        }
    }
    
    func currentReachabilityStatus() -> NWPath.Status {
        return currentNetworkStatus ?? .unsatisfied
    }
    
    func addListener(_ listener: NetworkStatusListener) {
        listeners.append(listener)
        listener.networkStatusDidChange(status: getPathStatus(status: currentNetworkStatus ?? .unsatisfied))
    }
    
    func removeListener(_ listener: NetworkStatusListener) {
        listeners.removeAll { $0 === listener }
    }
    
    private func notifyListeners(status: NWPath.Status) {
        for listener in listeners {
            listener.networkStatusDidChange(status: status)
        }
    }
}
