//
//  ViewModelFactory.swift
//  PatternExplorer
//
//  Created by Labtanza on 9/2/22.
//



import Foundation
import CoreLocation



protocol WeatherService {
    func getWeather(for location:CLLocation) async throws -> String
}

// Multiprotocol conformnce gets wierd.
//protocol LocationBroadcaster {
//    var locationStream:AsyncStream<CLLocation> { get }
//}

protocol LocationService {
    //LocationBroadcaster
    var locationStream:AsyncStream<CLLocation> { get }
}

protocol WeatherViewModelFactory {
    var weatherService: WeatherService { get }  //can't be let b/c protocol
    var locationService: LocationService { get }
    
    func makeWeatherDisplayVM() -> WeatherDisplayVM
}

protocol LocationViewModelFactory {
    var locationService: LocationService { get }
    
    func makeLocationVM() -> LocationViewModel
}


final class Services {
    var weatherService: WeatherService
    var locationService: LocationService
    
    init(weatherService: WeatherService, locationService: LocationService) {
        self.weatherService = weatherService
        self.locationService = locationService
    }
}

extension Services:WeatherViewModelFactory {

    func makeWeatherDisplayVM() -> WeatherDisplayVM {
        WeatherDisplayVM(weatherService: weatherService, locationStream: locationService.locationStream)
    }
    
}

extension Services:LocationViewModelFactory {
    @MainActor func makeLocationVM() -> LocationViewModel {
        return LocationViewModel(locationService: locationService)
    }
}

extension Services {
    static func forPreviews() -> Self {
        Self(
            weatherService: GoogleWeatherService(),
            locationService: MockLocationService()
        )
    }
}



