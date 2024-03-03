//
//  SearchView.swift
//  weather vf
//
//  Created by Alexandra on 02.03.2024.
//

import SwiftUI

struct SearchView: View {
    @Binding var searchText: String
    @ObservedObject var weatherVM: WeatherViewModel
    @State private var isShowingCityWeather = false
    
    var body: some View {
        HStack {
            Button {
                weatherVM.getWeather()
            } label: {
                Image(systemName: "location.circle.fill")
                    .renderingMode(.original)
                    .font(.system(size: 24))
            }

            TextField("Search City", text: $searchText, onCommit: {
                weatherVM.fetchWeatherByCityName()
                isShowingCityWeather = true 
            })
            .padding(5)
            .background(Color(.quaternarySystemFill))
            .cornerRadius(8)
            
            Button(action: {
                searchText = ""
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .font(.system(size: 24))
            }

            NavigationLink(destination: CityWeatherDetailView(city: City(name: searchText, coordinates: City.Coordinates(latitude: 0, longitude: 0)), weatherVM: weatherVM), isActive: $isShowingCityWeather) {
                EmptyView()
            } .hidden()
        }
        .padding(.horizontal)
    }
}

