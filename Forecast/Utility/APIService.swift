//
//  ApiService.swift
//  Forecast
//
//  Created by Alexandra on 02.03.2024.
//

import Foundation

struct ApiService{
    static let shared = ApiService()
    
    enum ApiError: Error{
        case error(_ errorString: String)
    }
    
    func getJson<T: Decodable>(urlString: String,
                               dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .secondsSince1970,
                               keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
                               completion: @escaping (Result<T, ApiError>) -> Void){
        guard let url = URL(string: urlString) else {
            completion(.failure(.error(NSLocalizedString("Error: invalid url", comment: "Local Language"))))
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request){ (data, response, error) in
            if let error = error{
                completion(.failure(.error("Error: \(error.localizedDescription)")))
                return
            }
            
            guard let data = data else{
                completion(.failure(.error(NSLocalizedString("Error: Data is currupt", comment: "Local Language"))))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            do{
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch let decodingError{
                completion(.failure(ApiError.error("Decoding Error: \(decodingError.localizedDescription)")))
            }
        }.resume()
    }
}
