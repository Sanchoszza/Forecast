//
//  Api.swift
//  weather vf
//
//  Created by Alexandra on 02.03.2024.
//

import Foundation

struct Api{
    static let weatherKey = "6b0f9abfd032ccca32d2eba6fab78445"
    
    static func checkForApiKey(){
        precondition(Api.weatherKey != "YourAPIKey", "Condition: \nEither your APIKey is invalid or you haven't filled it yet. \nPlease Fill Your APIKey")
    }
}
