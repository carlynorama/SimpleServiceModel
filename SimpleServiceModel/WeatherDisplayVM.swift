//
//  ViewModel.swift
//  SimpleServiceModel
//
//  Created by Labtanza on 9/2/22.
//

import Foundation
import CoreLocation


class WeatherDisplayVM:ObservableObject {
    @Published var weatherInfo:String = ""
    //@Published var locationInfo:String = ""
    
    let weatherService:WeatherService
    let locationService:LocationBroadcaster
    //let locationStream:AsyncStream<CLLocation>
    
    var lastLocation:CLLocation? = nil
    
    init(weatherService: WeatherService, locationService: LocationBroadcaster) {
        //self.weatherInfo = weatherInfo
        //self.locationInfo = locationInfo
        self.weatherService = weatherService
        self.locationService = locationService
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
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            print("Checking")
            if self.locationService.currentLocation != self.lastLocation {
                print("Not the same")
                self.lastLocation = self.locationService.currentLocation
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
    
    
}
