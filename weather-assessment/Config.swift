//
//  Config.swift
//  weather-assessment
//
//  Created by Eugenio Baglieri on 07/10/2019.
//  Copyright © 2019 PED. All rights reserved.
//

import Foundation

public struct Config {
    let baseUrl: URL
    let apiKey: String
    let iconDownloadUrl: URL
    
    static var `default` = Config(baseUrl: URL(string: "http://api.openweathermap.org/data/2.5")!,
                                  apiKey: "d73ebe7666213fce3740edab89797838",
                                  iconDownloadUrl: URL(string: "http://openweathermap.org/img/wn")!)
}
