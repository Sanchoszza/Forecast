//
//  CurrentView.swift
//  Forecast
//
//  Created by Alexandra on 02.03.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var weatherVM = WeatherViewModel()
    
    var body: some View {
        if weatherVM.isLoading{
            ProgressView(NSLocalizedString("Loading", comment: "Loading")).font(.largeTitle)
        } else{
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color("BottomBG"), Color("TopBG")]), startPoint: .topLeading, endPoint: .bottomLeading)
                    .ignoresSafeArea()
                
                CityListView(weatherVM: weatherVM)
                    .onAppear {
                        weatherVM.getWeather()
                    }
                    .alert(isPresented: $weatherVM.showAlert) {
                        Alert(title: Text(NSLocalizedString("Ошибка", comment: "Error")), message: Text(NSLocalizedString("Пожалуйста, включите службы геолокации в настройках вашего устройства", comment: "Please enable location services in your device settings")), dismissButton: .default(Text(NSLocalizedString("OK", comment: "OK"))))
                    }
            }
        }
    }
}
