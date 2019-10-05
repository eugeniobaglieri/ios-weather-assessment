//
//  Coodinates.swift
//  weather-assessment
//
//  Created by Eugenio Baglieri on 04/10/2019.
//  Copyright © 2019 PED. All rights reserved.
//

struct Coordinates {
    let latitude: Double
    let longitude: Double
}

extension Coordinates: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
    
}

