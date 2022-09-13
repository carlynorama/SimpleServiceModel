//
//  SimpleServiceModelApp.swift
//  SimpleServiceModel
//
//  Created by Labtanza on 9/2/22.
//

import SwiftUI

//TODO: Where is the most performant place to put this? 
var services:Services = Services(
    weatherService: WeatherKitService(),
    locationService: MockLocationService(),
    graphicsDriver: DisplayGenerator()
)

@main
struct SimpleServiceModelApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(services.makeWeatherDisplayVM())
                .environmentObject(services.makeLocationVM())
        }
    }
}
