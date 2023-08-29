//
//  NetworkMonitor.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 8/26/23.
//

import Foundation
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()

    let monitor = NWPathMonitor()
    
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true

    func startMonitoring() {
        print("\n\n\n\n********************************** START NETWORK MONITORING **********************************\n\n\n\n")
        monitor.pathUpdateHandler = { [weak self] path in
            print("\n\n\n\n********************************** IN COMPLETION HANDLER NETWORK MONITORING **********************************\n\n\n\n")
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive

            if path.status == .satisfied {
                print("We're connected!")
                // post connected notification
            } else {
                print("No connection.")
                // post disconnected notification
            }
            print(path.isExpensive)
        }

        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        print("\n\n\n\n********************************** STOP NETWORK MONITORING **********************************\n\n\n\n")
        monitor.cancel()
    }
}
