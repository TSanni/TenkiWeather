//
//  BackgroundTasksManager.swift
//  Tenki Weather
//
//  Created by Tomas Sanni on 3/28/24.
//

import Foundation
import BackgroundTasks


class BackgroundTasksManager {
    
    let request = BGAppRefreshTaskRequest(identifier: "getCurrentWeather") // Mark 1
    
    func startBackgroundTasks() {
        request.earliestBeginDate = Calendar.current.date(byAdding: .minute, value: 30, to: Date()) // Mark 2
        do {
            try BGTaskScheduler.shared.submit(request) // Mark 3
            print("Background Task Scheduled!") // place breakpoint here to test background test [e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"getCurrentWeather"]
        } catch(let error) {
            print("Scheduling Error \(error)")
        }

    }
}
