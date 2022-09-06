//
//  WeatherView.swift
//  SimpleServiceModel
//
//  Created by Labtanza on 9/3/22.
//

import SwiftUI

struct WeatherView: View {
    @EnvironmentObject var weatherViewModel:WeatherDisplayVM
    
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(services.graphicsDriver.backgroundColor)
            Text(weatherViewModel.weatherInfo)
        }.onAppear(perform: weatherViewModel.listen)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView().environmentObject(Services.forPreviews.makeWeatherDisplayVM())
    }
}
