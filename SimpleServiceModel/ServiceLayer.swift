//
//  ViewModelFactory.swift
//  PatternExplorer
//
//  Created by Labtanza on 9/2/22.
//



import Foundation
import CoreLocation
import SwiftUI



protocol WeatherService {
    func getWeather(for location:CLLocation) async throws -> String
}

// Multiprotocol conformnce gets wierd.

protocol LocationBroadcaster {
    var locationStream:AsyncStream<CLLocation> { get }
    var currentLocation:CLLocation { get }
}

protocol LocationUpdater:AnyObject {
    func update(with location:CLLocation)
}

protocol LocationService:LocationBroadcaster & LocationUpdater {
    
}

protocol GraphicsDriver {
    //Used by the view to display
    var epicenter:CGPoint { get }
    func updateSize(to size:CGSize)
    var backgroundColor:Color { get }
    
    //Used by others to influence display
    func updateFactors(_ x:Double,_ y:Double)
}

protocol WeatherViewModelFactory {
    var weatherService: WeatherService { get }  //can't be let b/c protocol
    var locationBroadcaster: LocationBroadcaster { get }
    
    func makeWeatherDisplayVM() -> WeatherDisplayVM
}

protocol LocationViewModelFactory {
    var locationService: LocationService { get }
    func makeLocationVM() -> LocationViewModel
}






struct Services {
    var weatherService: WeatherService
    var locationService: LocationService
    var graphicsDriver: GraphicsDriver
    
    var locationBroadcaster: LocationBroadcaster {
        locationService
    }
    
    init(weatherService: WeatherService, locationService: LocationService, graphicsDriver: GraphicsDriver) {
        self.weatherService = weatherService
        self.locationService = locationService
        self.graphicsDriver = graphicsDriver
    }
}

extension Services:WeatherViewModelFactory {

    func makeWeatherDisplayVM() -> WeatherDisplayVM {
        //WeatherDisplayVM(weatherService: weatherService, locationStream: locationBroadcaster.locationStream)
        WeatherDisplayVM(
            weatherService: weatherService,
            locationService: locationBroadcaster,
            displayGenerator: graphicsDriver
        )
    }
    
}

extension Services:LocationViewModelFactory {
    @MainActor func makeLocationVM() -> LocationViewModel {
        return LocationViewModel(locationService: locationService)
    }
}

extension Services {
    static let forPreviews =
        Services(
            weatherService: GoogleWeatherService(),
            locationService: MockLocationService(),
            graphicsDriver: DisplayGenerator.shared
        )
    
}



