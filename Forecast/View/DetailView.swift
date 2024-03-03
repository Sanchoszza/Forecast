//
//  DetailView.swift
//  weather vf
//
//  Created by Alexandra on 02.03.2024.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject var weatherVM: WeatherViewModel
    
    var body: some View {
        if let current = weatherVM.current{
            Divider()
            VStack(alignment: .leading){
                HStack{
                    VStack(alignment: .leading){
                        DetailCell(title: "Sunrise", detail: "\(current.sunrise.hourMiniteAmPm(weatherVM.timeZoneOffset))")
                        DetailCell(title: "Pressure", detail: "\(current.pressure) hPa")
                        DetailCell(title: "Visability", detail: "\(current.visibility/1000) Km")
                    }
                    
                    Divider()
                    VStack(alignment: .leading){
                        DetailCell(title: "Sunset", detail: "\(current.sunset.hourMiniteAmPm(weatherVM.timeZoneOffset))")
                        DetailCell(title: "Wind", detail: "\(current.windSpeedWithDirection)")
                        DetailCell(title: "UV Index", detail: current.uvi.roundedString(to: 0))
                    }
                }
            }.padding(.horizontal)
        }
    }
}

