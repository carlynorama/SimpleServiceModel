//
//  MockWeatherServices.swift
//  SimpleServiceModel
//
//  Created by Labtanza on 9/2/22.
//

import Foundation
import CoreLocation

enum WeatherProfile {
    case sunny, cloudy, rainy, cold
    
//    Arctic Circle     66° 34′ (66.57°) N
//    Tropic of Cancer     23° 26′ (23.43°) N
//    Tropic of Capricorn     23° 26′ (23.43°) S
//    Antarctic Circle     66° 34′ (66.57°) S
    
    static func weatherDescription(for location:CLLocation) -> String {
        switch location.coordinate.latitude {
        case let x where (-23..<23).contains(x):
            return "sunny"
        case let x where (23..<66).contains(x.magnitude):
            return "cloudy"
        case let x where (66...90).contains(x.magnitude):
            return "not cold enough"
        case let x where x.magnitude > 90:
            return "not earthly"
        default:
            return "undefined"
        }
    }
}


final class WeatherKitService: WeatherService {
    func getWeather(for location:CLLocation) async throws -> String {
        "It's \(WeatherProfile.weatherDescription(for: location)) in \(location) says WeatherKitService"
    }
}

actor GoogleWeatherService: WeatherService {
    func getWeather(for location:CLLocation) async throws -> String {
        "It's \(WeatherProfile.weatherDescription(for: location)) in \(location) says GoogleWeatherService"
    }
}

struct MockWeatherService: WeatherService {
    func getWeather(for location:CLLocation) async throws -> String {
        "It's \(WeatherProfile.weatherDescription(for: location)) in \(location) says MockWeatherSerice"
    }
}
