//
//  WeatherApp.swift
//  Weather
//
//  Created by Tomas Sanni on 5/27/23.
//




import SwiftUI

@main
struct WeatherApp: App {
    @StateObject private var dataController = PersistenceController()
    
    var body: some Scene {
        WindowGroup {
//            NavigationView {
                MainScreen()
                    .environment(\.managedObjectContext, dataController.container.viewContext)
//            }
        }
    }
}
