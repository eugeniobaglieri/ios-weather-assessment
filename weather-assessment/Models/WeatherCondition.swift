//
//  WeatherCondition.swift
//  weather-assessment
//
//  Created by Eugenio Baglieri on 04/10/2019.
//  Copyright © 2019 PED. All rights reserved.
//

struct WeatherCondition {
    let identifier: Int
    let name: String
    let description: String
    let iconCode: String
}

extension WeatherCondition: Codable {
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name = "main"
        case description
        case iconCode = "icon"
    }
    
}
