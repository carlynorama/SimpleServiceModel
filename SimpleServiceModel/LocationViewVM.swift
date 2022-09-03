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
    
    @Published var currentLocation = MockLocationService.locations[0]
    
    @Published var pastLocations:[CLLocation] = []
    
    
    private func connectToStream(_ stream:AsyncStream<CLLocation>) async {
        for await update in stream {
            pastLocations.append(currentLocation)
            currentLocation = update
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
