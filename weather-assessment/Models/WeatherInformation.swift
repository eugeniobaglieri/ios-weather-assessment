//
//  Weather.swift
//  weather-assessment
//
//  Created by Eugenio Baglieri on 04/10/2019.
//  Copyright © 2019 PED. All rights reserved.
//

struct WeatherInformation {
    let cityID: Int
    let cityName: String
    let weather: [WeatherCondition]
    let wind: WindCondition
    let clouds: CloudsCondition
    let atmosphere: AtmosphericCondition
}

extension WeatherInformation: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case cityID = "id"
        case cityName = "name"
        case weather
        case wind
        case clouds
        case atmosphere = "main"
    }
    
}
