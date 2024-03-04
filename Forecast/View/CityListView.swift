//
//  CityListView.swift
//  Forecast
//
//  Created by Alexandra on 03.03.2024.
//
import SwiftUI

struct CityListView: View {
    @ObservedObject var weatherVM: WeatherViewModel
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color("BottomBG"), Color("TopBG")]), startPoint: .topLeading, endPoint: .bottomLeading)
                    .ignoresSafeArea()
                
                VStack {
                    SearchView(searchText: $searchText, weatherVM: weatherVM)
                    
                    List {
                        ForEach(filteredCities, id: \.name) { city in
                            NavigationLink(destination: CityWeatherDetailView(city: city, weatherVM: weatherVM)) {
                                VStack {
                                    Text(city.name)
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .background(Color.clear)
                            }
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: delete)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationBarTitle("Мои города")
            .navigationBarItems(trailing: EditButton())
            .onReceive(weatherVM.objectWillChange) { _ in
            }
        }
        .onAppear {
            weatherVM.searchCityName = searchText
            weatherVM.fetchWeatherByCityName()
        }
    }
    
    private var filteredCities: [City] {
        if searchText.isEmpty {
            return weatherVM.selectedCities
        } else {
            return weatherVM.selectedCities.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    private func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            weatherVM.removeCity(at: index)
        }
    }
}



struct CityWeatherDetailView: View {
    let city: City
    @ObservedObject var weatherVM: WeatherViewModel
    @State private var isAdded: Bool = false // Добавлен ли город

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("BottomBG"), Color("TopBG")]), startPoint: .topLeading, endPoint: .bottomLeading)
                .ignoresSafeArea()
            
            VStack (spacing: 2) {
                ScrollView(showsIndicators: false) {
                    VStack {
                        CurrentView(weatherVM: weatherVM)
                        ScrollView(showsIndicators: false) {
                            DailyView(weatherVM: weatherVM)
                            HourlyView(weatherVM: weatherVM)
                            DetailView(weatherVM: weatherVM)
                        }
                    }
                }
            }
            .navigationBarTitle(city.name)
            .navigationBarItems(leading: EmptyView(), trailing: addButton)
            .onAppear {
                weatherVM.searchCityName = city.name
                weatherVM.fetchWeatherByCityName()
//                weatherVM.fetchWeather(for: city)
                isAdded = weatherVM.selectedCities.contains { $0.name == city.name }
            }
            .onDisappear {
                if !isAdded {
                    if let index = weatherVM.selectedCities.firstIndex(where: { $0.name == city.name }) {
                        weatherVM.removeCity(at: index)
                    }
                }
            }
        }
    }
    
    private var addButton: some View {
            Button(action: {
                addCity()
            }) {
                Image(systemName: isAdded ? "checkmark.circle.fill" : "plus.circle.fill")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
            }
        }

    private func addCity() {
        weatherVM.addCity(city: city)
        isAdded = true
    }
}

