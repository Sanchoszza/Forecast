//
//  DetailView.swift
//  Forecast
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
                        DetailCell(title: NSLocalizedString("Sunrise", comment: "Sunrise"), detail: "\(current.sunrise.hourMiniteAmPm(weatherVM.timeZoneOffset))")
                        DetailCell(title: NSLocalizedString("Pressure", comment: "Pressure"), detail: "\(current.pressure) hPa")
                        DetailCell(title: NSLocalizedString("Visibility", comment: "Visibility"), detail: "\(current.visibility/1000) Km")
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading){
                        DetailCell(title: NSLocalizedString("Sunset", comment: "Sunset"), detail: "\(current.sunset.hourMiniteAmPm(weatherVM.timeZoneOffset))")
                        DetailCell(title: NSLocalizedString("Wind", comment: "Wind"), detail: "\(current.windSpeedWithDirection)")
                        DetailCell(title: NSLocalizedString("UV Index", comment: "UV Index"), detail: current.uvi.roundedString(to: 0))
                    }
                }

            }.padding(.horizontal)
        }
    }
}

