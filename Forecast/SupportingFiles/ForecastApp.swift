//
//  ForecastApp.swift
//  Forecast
//
//  Created by Alexandra on 02.03.2024.
//

import SwiftUI

@main
struct ForecastApp: App {
    
    @StateObject var weatherVM = WeatherViewModel()
    
    private let message = NSLocalizedString("Go to Setting >> Privacy >> Location Services >> ForecastApp >> Ask Next Time", comment: "Location services are denied")
    private let settingsButtonTitle = NSLocalizedString("GO TO SETTINGS", comment: "Settings alert button")
 
    var body: some Scene {
        WindowGroup {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color("BottomBG"), Color("TopBG")]), startPoint: .topLeading, endPoint: .bottomLeading)
                    .ignoresSafeArea()
                
                ContentView()
                    .environmentObject(weatherVM)
                    .alert(isPresented: $weatherVM.showAlert) {
                        Alert(title: Text(NSLocalizedString("LOCATION SERVICE DENID LAST TIME", comment: "Location services alert title")),
                              message: Text(message),
                              primaryButton: .default(Text(settingsButtonTitle)){
                                  if let settingsURl = URL(string: UIApplication.openSettingsURLString){
                                      UIApplication.shared.open(settingsURl, options: [:],
                                                                  completionHandler: nil)
                                  }
                              }, secondaryButton: .cancel()
                        )
                    }
                    .alert(item: $weatherVM.appError) { (appAlert) in
                        Alert(title: Text("Error"), message: Text(
                            """
                            \(appAlert.errorString)
                            Please try again leter
                            """
                        ))
                    }
            }
        }
    }
}
