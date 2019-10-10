//
//  AtmosphericCondition.swift
//  weather-assessment
//
//  Created by Eugenio Baglieri on 04/10/2019.
//  Copyright © 2019 PED. All rights reserved.
//

struct AtmosphericCondition {
    let temperature: Double
    let pressure: Double
    let humidity: Double
}

extension AtmosphericCondition: Codable {
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case pressure
        case humidity
    }
    
}
