//
//  LocationViewVM.swift
//  SimpleServiceModel
//
//  Created by Labtanza on 9/3/22.
//

import Foundation
import CoreLocation

@MainActor
class LocationViewModel:ObservableObject {
    var locationService:LocationService
    
    init(locationService: LocationService) {
        self.locationService = locationService
    }
    
    @Published var currentLocation = CLLocation(
        latitude: 35.0536909,
        longitude: -118.242766)//MockLocationService.locations[0]
    
    @Published var pastLocations:[CLLocation] = []
    
    @Published var counter:Double = 0
    
    
    private func connectToStream(_ stream:AsyncStream<CLLocation>) async {
        for await update in stream {
            pastLocations.append(currentLocation)
            currentLocation = update
            locationService.update(with: currentLocation)
            print("new location")
        }
    }
    
    private func disconnectStream() {
        //learn how to do???
        //locationService.killStreams?
    }
    
    func listen() async {
        await connectToStream(locationService.locationStream)
    }
}
