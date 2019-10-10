//
//  WeatherRequest.swift
//  weather-assessment
//
//  Created by Eugenio Baglieri on 07/10/2019.
//  Copyright © 2019 PED. All rights reserved.
//

import Foundation
import Alamofire

enum WeatherRequestError: Error {
    case cancelled
    case cityNotFound
    case networkError // This is too generic
}

typealias WeatherResult = Result<WeatherInformation, WeatherRequestError>
typealias WeatherRequestCompletionHandler = (WeatherResult) -> Void

class WeatherRequest {
    
    private let baseUrl: URL
    private let apiKey: String
    private let city: String
    private(set) var completionHandler: WeatherRequestCompletionHandler?
    private var dataRequest: DataRequest?
    
    init(configuration: Config = .default, city: String, completionHandler: @escaping WeatherRequestCompletionHandler) {
        self.baseUrl = configuration.baseUrl
        self.apiKey = configuration.apiKey
        self.city = city
        self.completionHandler = completionHandler
    }
    
    func run() {
        
        let url = baseUrl.appendingPathComponent("weather")
        
        let query = [
            "q" : city,
            "units" : "metric",
            "apiKey" : apiKey,
            "lang" : "it"
        ]
        
        dataRequest = AF.request(url, method: .get, parameters: query, encoder: URLEncodedFormParameterEncoder.default, headers: nil, interceptor: nil)
        dataRequest!.responseDecodable(of: WeatherInformation.self) { [weak self] (response) in
            guard let strongSelf = self else { return }
            
            if response.response?.statusCode == 404 {
                strongSelf.completionHandler?(.failure(.cityNotFound))
            }
            
            switch response.result {
            case .success(let weatherInfo):
                strongSelf.completionHandler?(.success(weatherInfo))
            case .failure(let afError):
                switch afError {
                case .explicitlyCancelled:
                    strongSelf.completionHandler?(.failure(.cancelled))
                default:
                    strongSelf.completionHandler?(.failure(.networkError))
                }
            }
            strongSelf.completionHandler = nil
        }
    }
    
    func cancel() {
        dataRequest?.cancel()
    }
    
}

