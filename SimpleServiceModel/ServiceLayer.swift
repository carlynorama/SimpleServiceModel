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

protocol LocationBroadcaster {
    //LocationBroadcaster
    var locationStream:AsyncStream<CLLocation> { get }
    var currentLocation:CLLocation { get }
}

protocol LocationUpdater:AnyObject {
    func update(with location:CLLocation)
}

protocol LocationService:LocationBroadcaster & LocationUpdater {
    
}

protocol WeatherViewModelFactory {
    var weatherService: WeatherService { get }  //can't be let b/c protocol
    var locationBroadcaster: LocationBroadcaster { get }
    
    func makeWeatherDisplayVM() -> WeatherDisplayVM
}

protocol LocationViewModelFactory {
    //var locationService: LocationService { get }
    
    func makeLocationVM() -> LocationViewModel
}


final class Services {
    var weatherService: WeatherService
    var locationService:LocationService
    
    var locationBroadcaster: LocationBroadcaster {
        locationService
    }
    
    init(weatherService: WeatherService, locationService: LocationService) {
        self.weatherService = weatherService
        self.locationService = locationService
    }
}

extension Services:WeatherViewModelFactory {

    func makeWeatherDisplayVM() -> WeatherDisplayVM {
        //WeatherDisplayVM(weatherService: weatherService, locationStream: locationBroadcaster.locationStream)
        WeatherDisplayVM(weatherService: weatherService, locationService: locationBroadcaster)
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



