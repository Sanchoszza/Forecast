//
//  WeatherDataModel.swift
//  Forecast
//
//  Created by Alexandra on 02.03.2024.
//

import Foundation

struct WeatherDataModel: Codable{
    let timezone_offset: Int
    let current: Current
    let daily: [Daily]
    let hourly: [Hourly]
    
    
    struct Current: Codable{
        let dt: Int
        let sunrise: Int
        let sunset: Int
        let temp: Double
        let feels_like: Double
        let pressure: Int
        let humidity: Int
        let uvi: Double
        let clouds: Int
        let visibility: Int
        let wind_speed: Double
        let wind_deg: Int
        let weather: [Weather]
    }
    
    struct Hourly: Codable{
        let dt: Int
        let temp: Double
        let humidity: Int
        let clouds: Int
        let pop: Double
        let weather: [Weather]
    }
    
    struct Daily: Codable{
        let dt: Int
        let temp: Temp
        let clouds: Int
        let humidity: Int
        let pop: Double
        let weather: [Weather]
        
        struct Temp: Codable{
            let min: Double
            let max: Double
        }
    }
    
    struct Weather: Codable{
        let description: String
        let icon: String
    }
}


struct City: Codable, Equatable{
    let name: String
    let coordinates: Coordinates
    
    struct Coordinates: Codable{
        let latitude: Double
        let longitude: Double
    }
    
    static func == (lhs: City, rhs: City) -> Bool {
            return lhs.name == rhs.name && lhs.coordinates.latitude == rhs.coordinates.latitude && lhs.coordinates.longitude == rhs.coordinates.longitude
        }
}

class CityStore: ObservableObject {
    @Published var cities: [City]
    
    init(cities: [City] = []) {
        self.cities = cities
    }

    func addCity(_ city: City) {
        cities.append(city)
    }
    
    func removeCity(_ city: City) {
        if let index = cities.firstIndex(of: city) {
            cities.remove(at: index)
        }
    }
    
    func moveCity(from source: IndexSet, to destination: Int) {
        cities.move(fromOffsets: source, toOffset: destination)
    }
}

