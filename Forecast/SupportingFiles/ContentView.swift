//
//  CurrentView.swift
//  weather vf
//
//  Created by Alexandra on 02.03.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var weatherVM = WeatherViewModel()
    
    var body: some View {
        if weatherVM.isLoading{
            ProgressView("Loading").font(.largeTitle)
        } else{
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color("BottomBG"), Color("TopBG")]), startPoint: .topLeading, endPoint: .bottomLeading)
                    .ignoresSafeArea()
                
                CityListView(weatherVM: weatherVM)
                    .onAppear {
                        weatherVM.getWeather()
                    }
                    .alert(isPresented: $weatherVM.showAlert) {
                        Alert(title: Text("Ошибка"), message: Text("Пожалуйста, включите службы геолокации в настройках вашего устройства"), dismissButton: .default(Text("OK")))
                    }
            }
        }
    }
}
