//
//  CloudsCondition.swift
//  weather-assessment
//
//  Created by Eugenio Baglieri on 04/10/2019.
//  Copyright © 2019 PED. All rights reserved.
//

struct CloudsCondition {
    let coverage: Double
}

extension CloudsCondition: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case coverage = "all"
    }
    
}
