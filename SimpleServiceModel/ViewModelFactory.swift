//
//  ViewModelFactory.swift
//  PatternExplorer
//
//  Created by Labtanza on 9/2/22.
//



import Foundation
import CoreLocation

class WeatherVaneVM:ObservableObject {
    @Published var weatherInfo:String = ""
    @Published var locationInfo:String = ""
    
    let weatherService:WeatherService
    let locationStream:AsyncStream<CLLocation>
    
    init(weatherService: WeatherService, locationStream: AsyncStream<CLLocation>) {
        //self.weatherInfo = weatherInfo
        //self.locationInfo = locationInfo
        self.weatherService = weatherService
        self.locationStream = locationStream
    }
    
    
}





protocol WeatherService {
    func getWeather(for location:String) async throws -> String
}

protocol LocationService {
    var locationStream:AsyncStream<CLLocation> { get }
}

protocol WeatherViewModelFactory {
    var weatherService: WeatherService { get }  //can't be let b/c protocol
    var locationService: LocationService { get }
    
    func makeViewModel() ->  WeatherVaneVM
    //func makeMessageViewController() -> LocationService
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
    
    func makeViewModel() -> WeatherVaneVM {
        WeatherVaneVM(weatherService: weatherService, locationStream: locationService.locationStream)
    }
    
    
}


final class WeatherKitService: WeatherService {
    func getWeather(for location:String) async throws -> String { "It's sunny in \(location)" }
}

actor GoogleWeatherService: WeatherService {
    func getWeather(for location:String) async throws -> String { "It's sunny in \(location)" }
}

struct MockWeatherService: WeatherService {
    func getWeather(for location:String) async throws -> String { "It's sunny in \(location)" }
}
