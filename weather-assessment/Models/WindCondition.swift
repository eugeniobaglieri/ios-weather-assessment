//
//  WindCondition.swift
//  weather-assessment
//
//  Created by Eugenio Baglieri on 04/10/2019.
//  Copyright © 2019 PED. All rights reserved.
//

struct WindCondition {
    let speed: Double
    let degrees: Double
}

extension WindCondition: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case speed
        case degrees = "deg"
    }
    
}
