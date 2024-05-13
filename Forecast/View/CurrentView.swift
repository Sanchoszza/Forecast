//
//  CurrentView.swift
//  Forecast
//
//  Created by Alexandra on 02.03.2024.
//

import SwiftUI

struct CurrentView: View {
    
    @StateObject var weatherVM: WeatherViewModel
    
    var body: some View {
        if let current = weatherVM.current{
            VStack(spacing: 2) {
                Text(weatherVM.currentCityName)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                HStack{
                    Text(current.weather[0].description.capitalized)
                    Divider()
                    Divider()
                    Text(NSLocalizedString("Feels like", comment: "Feels like") + ": \(current.feels_like.roundedString(to: 0))°")
                }.fixedSize()
                HStack{
                    Text("\(current.temp.roundedString(to: 0))°")
                    Divider()
                    Divider()
                    Image(systemName: current.weather[0].iconeImage).renderingMode(.original)
                }.fixedSize().font(.system(size: 75)).padding()
                HStack{
                    Text(NSLocalizedString("Cloud", comment: "Cloud") + ": \((current.clouds))%")
                    Divider()
                    Text(NSLocalizedString("Humidity", comment: "Humidity") + ": \(current.humidity)%")
                }.fixedSize()
            }

        }
    }
}
