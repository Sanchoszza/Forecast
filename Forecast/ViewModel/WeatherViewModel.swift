//
//  WeatherViewModel.swift
//  weather vf
//
//  Created by Alexandra on 02.03.2024.
//

import SwiftUI
import CoreLocation

final class WeatherViewModel: NSObject, ObservableObject{
    
    @Published var showAlert = false
    @Published var isLoading = true
    @Published var appError: AppError? = nil
    
    @Published var searchCityName = ""
    @Published var currentCityName = ""
    @Published var timeZoneOffset = 0
    @Published var selectedCities: [City] = [] {
        didSet{
            saveSelectedCities(selectedCities)
        }
    }
    
    @Published var current: WeatherDataModel.Current?
    @Published var daily: [WeatherDataModel.Daily]?
    @Published var hourly: [WeatherDataModel.Hourly]?
    
    let apiService = ApiService.shared
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        requestLocation()
        
        selectedCities = loadSelectedCities()
    }
    
    func getWeather(){
        if let location = locationManager.location{
            perfomWeatherRequest(with: location)
        }
    }
    
    func fetchWeatherByCityName() {
        if !searchCityName.isEmpty {
            CLGeocoder().geocodeAddressString(searchCityName) { (placemarks, error) in
                if let location = placemarks?.first?.location {
                    // Проверяем, не содержится ли уже город с таким именем в списке
                    if !self.selectedCities.contains(where: { $0.name == self.searchCityName }) {
                        self.perfomWeatherRequest(with: location)
                        
                        let newCity = City(name: self.searchCityName, coordinates: City.Coordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
                        self.selectedCities.append(newCity)
                        self.saveSelectedCity(newCity)
                    } else {
                        // Если город уже есть в списке, просто очищаем поле ввода
                        self.searchCityName = ""
                    }
                }
            }
        }
    }



    func saveSelectedCity(_ city: City) {
        var selectedCities = loadSelectedCities()
        selectedCities.append(city)
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(selectedCities) {
            UserDefaults.standard.set(encoded, forKey: "selectedCities")
        }
    }

    private func saveSelectedCities(_ cities: [City]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(cities) {
            UserDefaults.standard.set(encoded, forKey: "selectedCities")
        }
    }


    
    func loadSelectedCities() -> [City]{
        if let savedCitiesData = UserDefaults.standard.data(forKey: "selectedCities"){
            let decoder = JSONDecoder()
            if let loadCities = try? decoder.decode([City].self, from: savedCitiesData){
                return loadCities
            }
        }
        return []
    }
    
    func addCity(city: City) {
        if !selectedCities.contains(where: { $0.name == city.name }) {
            selectedCities.append(city)
            saveSelectedCities(selectedCities)
        }
    }



    
    func removeCity(at index: Int) {
        print("City was removed")
        selectedCities.remove(at: index)
        saveSelectedCities(selectedCities)
        objectWillChange.send()
    }


    
    func perfomWeatherRequest(with location: CLLocation){
        Api.checkForApiKey()
        let coordinate = location.coordinate
        let urlString = "https://api.openweathermap.org/data/2.5/onecall?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&exclude=minutely,alerts&appid=\(Api.weatherKey)&units=metric"
        apiService.getJson(urlString: urlString) { (result: Result<WeatherDataModel, ApiService.ApiError>) in
            switch result{
            case .success(let result):
                DispatchQueue.main.async {
                    [weak self] in
                    self?.timeZoneOffset = result.timezone_offset
                    self?.current = result.current
                    self?.daily = result.daily
                    self?.hourly = result.hourly
                    self?.getCityName(of: location)
                    self?.isLoading = false
                    self?.searchCityName = ""
                }
            case .failure(let apiError):
                print("Error: \(apiError.localizedDescription)")
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.appError = AppError(errorString: "\(result)")
                }
            }
        }
    }
    
    func getCityName(of location: CLLocation){
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemark = placemarks?.first{
                self.currentCityName = "\(placemark.locality ?? "") \(placemark.country ?? "")"
            }
        }
    }
}


extension WeatherViewModel: CLLocationManagerDelegate{
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        requestLocation()
    }
    
    private func requestLocation(){
        guard CLLocationManager.locationServicesEnabled() else {return}
        
        switch locationAuthorizationStatus(){
        case .notDetermined, .authorizedAlways, .authorizedWhenInUse:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestLocation()
        case .restricted: break
        case .denied: showAlert = true; isLoading = false
        @unknown default: break
        }
    }
    
    func locationAuthorizationStatus()-> CLAuthorizationStatus{
        let locationManager = CLLocationManager()
        var locationAuthorizationStatus: CLAuthorizationStatus
        locationAuthorizationStatus = CLLocationManager.authorizationStatus()
        return locationAuthorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        getWeather()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.isLoading = false
        print(error.localizedDescription)
    }
}
