//
//  LocationOnlyView.swift
//  SimpleServiceModel
//
//  Created by Labtanza on 9/3/22.
//

import SwiftUI
import CoreLocation




struct LocationView: View {
    @EnvironmentObject var viewModel:LocationViewModel
    
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

struct LocationOnlyView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView().environmentObject(LocationViewModel(locationService: MockLocationService()))
    }
}
