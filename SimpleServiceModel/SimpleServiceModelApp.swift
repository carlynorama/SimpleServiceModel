//
//  SimpleServiceModelApp.swift
//  SimpleServiceModel
//
//  Created by Labtanza on 9/2/22.
//

import SwiftUI

@main
struct SimpleServiceModelApp: App {
    var services:Services = Services(
        weatherService: WeatherKitService(),
        locationService: MockLocationService()
    )
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(services.makeWeatherDisplayVM())
                .environmentObject(services.makeLocationVM())
        }
    }
}
