//
//  WeatherDMExt.swift
//  Forecast
//
//  Created by Alexandra on 02.03.2024.
//

import Foundation

extension WeatherDataModel.Weather{
    var iconeImage: String{
        switch icon {
                case "01d": return "sun.max.fill"
                case "01n": return "moon.stars.fill"
                case "02d": return "cloud.sun.fill"
                case "02n": return "cloud.moon.fill"
                case "03n", "03d": return "cloud.fill"
                case "04d", "04n": return "smoke.fill"
                case "09d", "09n": return "cloud.drizzle.fill"
                case "10d": return "cloud.sun.rain.fill"
                case "10n": return "cloud.moon.rain.fill"
                case "11d": return "cloud.sun.bolt.fill"
                case "11n": return "cloud.moon.bolt.fill"
                case "13d", "13n": return "snow"
                case "50d": return "sun.haze.fill"
                case "50n": return "cloud.fog.fill"
                default: return "cloud.fill"
        }
    }
}

extension WeatherDataModel.Current {
    var windSpeedWithDirection: String {
        let windSpeed = "\((wind_speed * 3.6).roundedString(to: 1)) " + NSLocalizedString("Km/h", comment: "")
        switch wind_deg {
        case 0, 360: return NSLocalizedString("N", comment: "") + " \(windSpeed)"
        case 90: return NSLocalizedString("E", comment: "") + " \(windSpeed)"
        case 180: return NSLocalizedString("S", comment: "") + " \(windSpeed)"
        case 270: return NSLocalizedString("W", comment: "") + " \(windSpeed)"
        case 1..<90: return NSLocalizedString("NE", comment: "") + " \(windSpeed)"
        case 91..<180: return NSLocalizedString("SE", comment: "") + " \(windSpeed)"
        case 181..<270: return NSLocalizedString("SW", comment: "") + " \(windSpeed)"
        case 271..<360: return NSLocalizedString("NW", comment: "") + " \(windSpeed)"
        default: return windSpeed
        }
    }
}
