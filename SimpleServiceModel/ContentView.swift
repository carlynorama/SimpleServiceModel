//
//  ContentView.swift
//  PatternExplorer
//
//  Created by Labtanza on 9/2/22.
//

import SwiftUI
import CoreLocation






struct ContentView: View {
    @EnvironmentObject var weather:WeatherDisplayVM
    @EnvironmentObject var location:LocationViewModel
    
    
    var body: some View {
        HStack {
            GraphicDisplayView(displayGenerator: services.graphicsDriver)
            VStack {
                LocationView().environmentObject(location)
                WeatherView().environmentObject(weather)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Services.forPreviews.makeLocationVM())
            .environmentObject(Services.forPreviews.makeWeatherDisplayVM())
    }
}
