//
//  WeatherApp.swift
//  Weather
//
//  Created by Tomas Sanni on 5/27/23.
//




import SwiftUI

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MainScreen()
            }
            .navigationViewStyle(.stack)

        }
    }
}
