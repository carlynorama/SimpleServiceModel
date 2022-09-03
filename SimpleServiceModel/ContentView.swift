//
//  ContentView.swift
//  PatternExplorer
//
//  Created by Labtanza on 9/2/22.
//

import SwiftUI
import CoreLocation



@MainActor
class TempViewModel:ObservableObject {
    var locationService = MockLocationService()
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
