//
//  MockLocationService.swift
//  PatternExplorer
//
//  Created by Labtanza on 9/2/22.
//

import Foundation
import CoreLocation



class MockLocationService:LocationService {

    
//    func update() {
//        //TODO: This should initialize the stream, not the location VM.
//    }
    
    var currentLocation:CLLocation = CLLocation(
        latitude: 38.0536909,
        longitude: -118.242766)
    
    var locationStream: AsyncStream<CLLocation> {
        return AsyncStream { continuation in
            let items = Self.locationsToStream.timeSorted()
            for item in items {
                //print("got to the loop")
                Timer.scheduledTimer(withTimeInterval: item.interval, repeats: false) { timer in
                    //update(item.location)
                    continuation.yield(item.location)
                    if item == items.last {
                        continuation.finish()
                    }
                }
            }
            
        }
    }
    
    func update(with location:CLLocation) {
        currentLocation = location
    }
}
    
extension MockLocationService {
    
    struct TimedLocation:Timeable, Equatable {
        let location:CLLocation
        let interval:TimeInterval
    }
    
    
    static var locationsToStream:[TimedLocation] {
        let pen = zip(Self.locations, Self.changeTimes)
        return pen.map { pair in
            TimedLocation(location:pair.0, interval:pair.1)
        }
    }
    
    //static let changeTimes = [TimeInterval](repeating: Double.random(in: 1...10), count: locations.count)
    
    static let changeTimes:[TimeInterval] = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110]
    
    public static let locations = [
        CLLocation(
            latitude: 34.0536909,
            longitude: -118.242766),
        CLLocation(
            latitude: 25.7959,
            longitude: -80.2871),
        CLLocation(
            latitude: 41.8755616,
            longitude: -87.6244212),
        CLLocation(
            latitude: -41.286461,
            longitude: 174.776230),
        CLLocation(
            latitude: -51.630920,
            longitude: -69.224777),
        CLLocation(
            latitude: 47.562670,
            longitude: -52.710890),
        CLLocation(
            latitude: -53.161968,
            longitude: -70.909561),
        CLLocation(
            latitude: 37.765470,
            longitude: -100.015170),
        CLLocation(
            latitude: 3.52559,
            longitude: 36.0745062),
        CLLocation(
            latitude: -66.9000,
            longitude: 142.6667),
        CLLocation(
            latitude: 47.3686498,
            longitude: 8.5391825),
        CLLocation(
            latitude: -8.7467,
            longitude: 115.1668)
    ]
}
