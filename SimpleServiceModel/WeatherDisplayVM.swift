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
    let locationStream:AsyncStream<CLLocation>
    
    init(weatherService: WeatherService, locationStream: AsyncStream<CLLocation>) {
        //self.weatherInfo = weatherInfo
        //self.locationInfo = locationInfo
        self.weatherService = weatherService
        self.locationStream = locationStream
    }
    
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
        Task { @MainActor in 
            await connectToStream(locationStream)
        }
    }
    
    
}
