//
//  ViewModel.swift
//  SimpleServiceModel
//
//  Created by Labtanza on 9/2/22.
//

import Foundation
import CoreLocation


class WeatherDisplayVM:ObservableObject {

    
    let weatherService: WeatherService
    let locationService: LocationBroadcaster
    let displayGenerator: GraphicsDriver
    
    //let locationStream:AsyncStream<CLLocation>
    
    @Published var weatherInfo:String = ""
    
    var lastLocation:CLLocation? = nil
    
    init(weatherService: WeatherService, locationService: LocationBroadcaster, displayGenerator:GraphicsDriver) {
        //self.weatherInfo = weatherInfo
        //self.locationInfo = locationInfo
        self.weatherService = weatherService
        self.locationService = locationService
        self.displayGenerator = displayGenerator
    }
    
//    init(weatherService: WeatherService, locationStream: AsyncStream<CLLocation>) {
//        //self.weatherInfo = weatherInfo
//        //self.locationInfo = locationInfo
//        self.weatherService = weatherService
//        self.locationStream = locationStream
//    }
    
    @MainActor
    private func connectToStream(_ stream:AsyncStream<CLLocation>) async {
        for await update in stream {
            do {
                weatherInfo = "waiting..."
                weatherInfo = try await weatherService.getWeather(for: update)
            } catch {
                weatherInfo = "No information at this time."
                print("Weather serive error")
            }
        }
    }
    
    func listen() {
//        Task { @MainActor in
//            await connectToStream(locationStream)
//        }
        //TODO: Who kills this timer?
        //TODO: What happens if the location changes faster than the weather service provides info?
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            //print("Checking")
            if self.locationService.currentLocation != self.lastLocation {
                //print("Not the same")
                self.lastLocation = self.locationService.currentLocation
                self.updateDisplayPoint(self.lastLocation!)
                Task { @MainActor in
                    do {
                        self.weatherInfo = "waiting..."
                        self.weatherInfo = try await self.weatherService.getWeather(for: self.lastLocation!)
                    } catch {
                        self.weatherInfo = "No information at this time."
                        print("Weather serive error")
                    }
                }
            }
        }
    }
    
    func updateDisplayPoint(_ location:CLLocation) {
        let yFactor = (location.coordinate.latitude + 90.0)/180.0
        let xFactor = (location.coordinate.latitude + 180.0)/360
        print("updating display")
        displayGenerator.updateFactors(xFactor, yFactor)
    }
    
}
