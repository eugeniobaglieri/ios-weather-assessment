//
//  CachedWeather+CoreDataClass.swift
//  
//
//  Created by Eugenio Baglieri on 06/10/2019.
//
//

import Foundation
import CoreData

@objc(CachedWeather)
public class CachedWeather: NSManagedObject {
    
    // Cached result is valid if it's older less than 1 hour
    @objc
    var isExpired: Bool {
        let nowTime = Date().timeIntervalSince1970
        return nowTime > expiringTime
    }
    
    func weatherInformation() -> WeatherInformation? {
        guard let data = data else { return nil }
        let decoder = JSONDecoder()
        let weather = try? decoder.decode(WeatherInformation.self, from: data)
        return weather
    }

}
