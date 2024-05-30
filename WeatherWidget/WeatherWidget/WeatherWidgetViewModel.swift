//
//  WeatherWidgetViewModel.swift
//  Forecast
//
//  Created by Alexandra on 30.05.2024.
//

import Foundation
import CoreLocation

class WeatherWidgetViewModel: NSObject, ObservableObject {
    @Published var showAlert = false
    @Published var isLoading = true
    @Published var appError: AppError? = nil
    
    @Published var currentCityName = ""
    @Published var timeZoneOffset = 0
    
    @Published var current: WeatherDataModel.Current?
    @Published var daily: [WeatherDataModel.Daily]?
    @Published var hourly: [WeatherDataModel.Hourly]?
    
    let apiService = ApiService.shared
    let locationManager = CLLocationManager()
    //    var locationCompletion: (() -> Void)?
    
    override init() {
        super.init()
    }
    
    func getWeather(with coordinates: CLLocationCoordinate2D, completion: @escaping () -> Void) {
        perfomWeatherRequest(with: coordinates, completion: completion)
    }
    
    func perfomWeatherRequest(with coordinates: CLLocationCoordinate2D, completion: @escaping () -> Void) {
        Api.checkForApiKey()
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&exclude=minutely,alerts&appid=\(Api.weatherKey)&units=metric"
        apiService.getJson(urlString: urlString) { (result: Result<WeatherDataModel, ApiService.ApiError>) in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self.timeZoneOffset = result.timezone_offset
                    self.current = result.current
                    self.daily = result.daily
                    self.hourly = result.hourly
                    self.getCityName(for: coordinates) {
                        self.isLoading = false
                        completion()
                    }
                }
            case .failure(let apiError):
                print("Error: \(apiError.localizedDescription)")
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.appError = AppError(errorString: "\(result)")
                    completion()
                }
            }
        }
    }
    
    func getCityName(for coordinates: CLLocationCoordinate2D, completion: @escaping () -> Void) {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)) { (placemarks, error) in
            if let placemark = placemarks?.first {
                self.currentCityName = "\(placemark.locality ?? "") \(placemark.country ?? "")"
            }
            completion()
        }
    }
}
//    private func requestLocation() {
//        guard CLLocationManager.locationServicesEnabled() else {
//            showAlert = true
//            isLoading = false
//            locationCompletion?()
//            locationCompletion = nil
//            return
//        }
//
//        switch locationAuthorizationStatus() {
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//        case .authorizedAlways, .authorizedWhenInUse:
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.requestLocation()
//        case .restricted, .denied:
//            showAlert = true
//            isLoading = false
//            locationCompletion?()
//            locationCompletion = nil
//        @unknown default:
//            break
//        }
//    }
//
//       private func locationAuthorizationStatus() -> CLAuthorizationStatus {
//           return CLLocationManager.authorizationStatus()
//       }
//}


//extension WeatherWidgetViewModel: CLLocationManagerDelegate {
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        requestLocation()
//    }
//    
//    private func requestLocation() {
//        guard CLLocationManager.locationServicesEnabled() else {
//            showAlert = true
//            isLoading = false
//            return
//        }
//
//        switch locationAuthorizationStatus() {
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//        case .authorizedAlways, .authorizedWhenInUse:
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.requestLocation()
//        case .restricted, .denied:
//            showAlert = true
//            isLoading = false
//        @unknown default:
//            break
//        }
//    }
//
//    func locationAuthorizationStatus() -> CLAuthorizationStatus {
//        var locationAuthorizationStatus: CLAuthorizationStatus
//        locationAuthorizationStatus = CLLocationManager.authorizationStatus()
//        print("LOCATION STATUS \(locationAuthorizationStatus)")
//        return locationAuthorizationStatus
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        getWeather { }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        self.isLoading = false
//        print("Location Manager Error: \(error.localizedDescription)")
//    }
//}
