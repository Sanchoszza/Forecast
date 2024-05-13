//
//  DailyView.swift
//  Forecast
//
//  Created by Alexandra on 02.03.2024.
//

import SwiftUI

struct DailyView: View {
    
    @StateObject var weatherVM: WeatherViewModel
    
    var body: some View {
        if let daily = weatherVM.daily{
            Divider()
            VStack(alignment: .leading){
                Text(NSLocalizedString("Daily Forecast", comment: "Daily Forecast")).bold()
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ForEach(daily, id: \.dt){ day in
                            ZStack{
                                VStack{
                                    Text((daily[0].dt == day.dt ? NSLocalizedString("Today: ", comment: "Today: ") : day.dt.dayDateMonth)).font(.title)
                                    HStack{
                                        Text(NSLocalizedString("Max", comment: "Max") + " \(day.temp.max.roundedString(to: 0))°")
                                        Divider()
                                        Divider()
                                        Text(NSLocalizedString("Min", comment: "Min") + " \(day.temp.min.roundedString(to: 0))°")
                                    }
                                    Image(systemName: day.weather[0].iconeImage)
                                        .renderingMode(.original)
                                        .font(.system(size: 25))
                                        .padding(4)
                                    HStack{
                                        Text(NSLocalizedString("Rain", comment: "Rain") + ": \((day.pop * 100).roundedString(to: 0))%")
                                        Divider()
                                        Divider()
                                        Text(NSLocalizedString("Cloud", comment: "Cloud") + ": \(day.clouds)%")
                                    }
                                }.padding()
                            }
                            .background(Color(.red).opacity(0.35))
                            .cornerRadius(12)
                        }
                    }
                }
            }.padding(.horizontal,8)
        }
    }
}

