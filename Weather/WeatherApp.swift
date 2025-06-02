//
//  WeatherApp.swift
//  Weather
//
//  Created by Tomas Sanni on 5/27/23.
//

//MARK: Version 4.11.1 published to App Store

//TODO: Fix .renderingMode in files. This is the cause of the CoreSVG: Error: NULL ref passed to getObjectCoreSVG

import SwiftUI

@main
struct WeatherApp: App {
    
    init() {
        UserDefaults.standard.set("timeAdded", forKey: "sortType")
        UserDefaults.standard.set(false, forKey: "ascending")
    }
        
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainScreen()
            }
        }
    }
}
