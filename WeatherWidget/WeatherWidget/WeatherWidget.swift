//
//  WeatherWidget.swift
//  WeatherWidget
//
//  Created by Alexandra on 29.05.2024.
//

import WidgetKit
import SwiftUI
import CoreLocation

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), weather: nil, hourlyForecast: nil, cityName: "Loading...")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), weather: nil, hourlyForecast: nil, cityName: "Loading...")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [SimpleEntry] = []
        let weatherVM = WeatherWidgetViewModel()

        let coordinates = CLLocationCoordinate2D(latitude: 53.1507, longitude: 34.2218)

        weatherVM.getWeather(with: coordinates) {
            let entry: SimpleEntry
            if let currentWeather = weatherVM.current, let hourlyForecast = weatherVM.hourly?.prefix(6) {
                entry = SimpleEntry(date: Date(), weather: currentWeather, hourlyForecast: Array(hourlyForecast), cityName: weatherVM.currentCityName)
            } else {
                entry = SimpleEntry(date: Date(), weather: nil, hourlyForecast: nil, cityName: weatherVM.currentCityName)
            }
            entries.append(entry)
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let weather: WeatherDataModel.Current?
    let hourlyForecast: [WeatherDataModel.Hourly]?
    let cityName: String
}

struct WeatherWidgetEntryView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(spacing: 2) {
            
            if let current = entry.weather {
                Spacer()
                VStack {
                    Text(entry.cityName)
                        .font(.system(size: 16))
                        .multilineTextAlignment(.leading)
                    Text("\(current.temp.roundedString(to: 0))°")
                        .font(.system(size: 20))
                    Spacer()
                }
                .padding(.vertical, 5)
                .padding(.top, 5)
                
                HStack {
                    if let hourlyForecast = entry.hourlyForecast {
                        ForEach(hourlyForecast, id: \.dt) { hour in
                            VStack(spacing: 4) {
                                Spacer()
                                Text(hour.dt.hourMiniteAmPm())
                                    .font(.system(size: 14))
//                                HStack {
                                Spacer()
                                    Text("\(hour.temp.roundedString(to: 0))°")
    //                                Divider()
                                Spacer()
                                    Image(systemName: hour.weather[0].iconeImage)
                                        .renderingMode(.original)
                                        .font(.system(size: 14))
                                
                                Spacer()
//                                }
                                
    //                            .padding()
//                                HStack {
//                                    Text("Rain: \((hour.pop * 100).roundedString(to: 0))%")
//                                    Divider()
//                                    Text("Cloud: \(hour.clouds)%")
//                                }
                            }
                            .padding(.horizontal, 3)
//                            .background(Color(.systemPink).opacity(0.25))
//                            .cornerRadius(12)
                            .font(.system(size: 11))
                        }
                    }
                }
Spacer()
            } else {
                Text("Loading...")
            }
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color("BottomBG"), Color("TopBG")]), startPoint: .topLeading, endPoint: .bottomLeading))
        .containerBackground(LinearGradient(gradient: Gradient(colors: [Color("BottomBG"), Color("TopBG")]), startPoint: .topLeading, endPoint: .bottomLeading), for: .widget)
    }
}

struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Weather Widget")
        .description("Displays weather information for a specific location.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

//#Preview(as: .systemSmall) {
//    WeatherWidget()
//} timeline: {
//    SimpleEntry(date: .now, emoji: "😀")
//    SimpleEntry(date: .now, emoji: "🤩")
//}
