//
//  AppError.swift
//  Forecast
//
//  Created by Alexandra on 02.03.2024.
//

import Foundation

struct AppError: Identifiable{
    let id = UUID().uuidString
    let errorString: String
}
