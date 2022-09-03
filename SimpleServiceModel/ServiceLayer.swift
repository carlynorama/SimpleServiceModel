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

protocol LocationBroadcaster {
    var locationStream:AsyncStream<CLLocation> { get }
}

protocol WeatherViewModelFactory {
    var weatherService: WeatherService { get }  //can't be let b/c protocol
    var locationService: LocationBroadcaster { get }
    
    func makeViewModel() -> WeatherDisplayVM
    //func makeMessageViewController() -> LocationService
}

protocol LocationUpdater {
    
}

protocol LocationViewModelFactory {
    
}


final class Services {
    var weatherService: WeatherService
    //typealias BidirectionalLocationService = LocationBroadcaster & LocationUpdater
    var locationService: LocationBroadcaster //& LocationUpdater//BidirectionalLocationService
    
    init(weatherService: WeatherService, locationService: LocationBroadcaster) {
        self.weatherService = weatherService
        self.locationService = locationService
    }
}

extension Services:WeatherViewModelFactory {

    func makeViewModel() -> WeatherDisplayVM {
        WeatherDisplayVM(weatherService: weatherService, locationStream: locationService.locationStream)
    }
    
    
}



