//
//  HourlyView.swift
//  Forecast
//
//  Created by Alexandra on 02.03.2024.
//

import SwiftUI

struct HourlyView: View {
    
    @StateObject var weatherVM: WeatherViewModel
    
    var body: some View {
        if let hourly = weatherVM.hourly{
            Divider()
            VStack(alignment: .leading){
                Text("Hourly Forecast").bold()
                ScrollView(.horizontal, showsIndicators: false){
                    HStack{
                        ForEach(hourly, id: \.dt){ hour in
                            ZStack{
                                VStack{
                                    Text(hour.dt.hourMiniteAmPm(weatherVM.timeZoneOffset)).font(.title)
                                    HStack{
                                        Text("\(hour.temp.roundedString(to: 0))°")
                                        Divider()
                                        Divider()
                                        Image(systemName: hour.weather[0].iconeImage).renderingMode(.original)
                                    }
                                    .font(.system(size: 24))
                                    .padding()
                                    HStack{
                                        Text("Rain: \((hour.pop * 100).roundedString(to: 0))%")
                                        Divider()
                                        Divider()
                                        Text("Cloud: \(hour.clouds)%")
                                    }
                                }.padding()
                            }
                            .background(Color(.systemPink).opacity(0.25))
                            .cornerRadius(12)
                        }
                    }
                }
            }.padding(.horizontal, 8)
        }
    }
}
