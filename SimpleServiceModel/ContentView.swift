//
//  ContentView.swift
//  PatternExplorer
//
//  Created by Labtanza on 9/2/22.
//

import SwiftUI
import CoreLocation

extension CLLocation {
    var pretty:String {
        "lat:\(self.coordinate.latitude), long:\(self.coordinate.longitude)"
    }
}

@MainActor
class TempViewModel:ObservableObject {
    var locationService = MockLocationService()
    @Published var currentLocation = MockLocationService.locations[0]
    
    @Published var pastLocations:[CLLocation] = []
    
    func startListener(_ stream:AsyncStream<CLLocation>) async {
        for await update in stream {
            pastLocations.append(currentLocation)
            currentLocation = update
            print("new location")
        }
    }
    
    func listen() async {
        await startListener(locationService.locationStream)
    }
}


struct ContentView: View {
    @StateObject var viewModel = TempViewModel()
    var body: some View {
        VStack {
            Text("Hello, \(viewModel.currentLocation.pretty)")
            List(viewModel.pastLocations, id:\.self) {
                Text($0.pretty)
            }
        }.onAppear() {
            Task {
                await viewModel.listen()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
