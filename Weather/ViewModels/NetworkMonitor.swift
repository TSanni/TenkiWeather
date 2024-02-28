//
//  NetworkMonitor.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 8/26/23.
//

import Foundation
import Network

actor NetworkMonitor {
    static let shared = NetworkMonitor()
    
    let monitor = NWPathMonitor()
    
    private var status: NWPath.Status = .requiresConnection
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true
    
    private init() {
        Task {
            await updateStatus()
        }
    }
    
    func networkIsReachable() -> Bool {
        isReachable
    }
    
    private func startMonitoring() async -> NWPath {
        return await withCheckedContinuation { continuation in
            monitor.pathUpdateHandler = { path in
                continuation.resume(returning: path)
                //                self?.status = path.status
                //                self?.isReachableOnCellular = path.isExpensive
                //
                //                if path.status == .satisfied {
                //                    print("We're connected!")
                //                    // post connected notification
                //                } else {
                //                    print("No connection.")
                //                    // post disconnected notification
                //                }
                //                print(path.isExpensive)
            }
        }
        
        
        //        let queue = DispatchQueue(label: "NetworkMonitor")
        //        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
    private func updateStatus() async {
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
        let path = await startMonitoring()
        self.status = path.status
        self.isReachableOnCellular = path.isExpensive
    }
}
