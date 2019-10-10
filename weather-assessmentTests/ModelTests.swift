//
//  ModelTests.swift
//  weather-assessmentTests
//
//  Created by Eugenio Baglieri on 04/10/2019.
//  Copyright © 2019 PED. All rights reserved.
//

import XCTest
import CoreData
@testable import weather_assessment

class ModelTests: XCTestCase {

    lazy var jsonSampleData: Data = {
       guard let data = sampleWeather.data(using: .utf8) else {
            XCTFail("bad json string")
            return Data()
        }
        return data
    }()

    func test_GivenWeatherApiJson_returnDecodedWeather() {
        
        do {
            let weatherInfo = try JSONDecoder().decode(WeatherInformation.self, from: jsonSampleData)
            XCTAssert(weatherInfo.cityID == 2643743)
            XCTAssert(weatherInfo.cityName == "London")
            XCTAssert(weatherInfo.weather.count == 1)
            
            let weather = weatherInfo.weather.first!
            XCTAssert(weather.name == "Clouds")
            XCTAssert(weather.description == "broken clouds")
            XCTAssert(weather.identifier == 803)
            XCTAssert(weather.iconCode == "04d")
            
            let wind = weatherInfo.wind
            XCTAssert(wind.degrees == 240)
            XCTAssert(wind.speed == 4.1)
            
            let clouds = weatherInfo.clouds
            XCTAssert(clouds.coverage == 75)
            
            let atmo = weatherInfo.atmosphere
            XCTAssert(atmo.temperature == 14.48)
            XCTAssert(atmo.pressure == 1005)
            XCTAssert(atmo.humidity == 72)
            
        } catch let error {
            XCTFail("\(error)")
        }
    }
    
    func test_CachedWeatherToWeatherInformation() {
        let cached = CachedWeather(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
        cached.data = jsonSampleData
        
        XCTAssertNotNil(cached.weatherInformation())
       
        let weatherInfo = cached.weatherInformation()!
        
        XCTAssert(weatherInfo.cityID == 2643743)
        XCTAssert(weatherInfo.cityName == "London")
        XCTAssert(weatherInfo.weather.count == 1)
        
        let weather = weatherInfo.weather.first!
        XCTAssert(weather.name == "Clouds")
        XCTAssert(weather.description == "broken clouds")
        XCTAssert(weather.identifier == 803)
        XCTAssert(weather.iconCode == "04d")
        
        let wind = weatherInfo.wind
        XCTAssert(wind.degrees == 240)
        XCTAssert(wind.speed == 4.1)
        
        let clouds = weatherInfo.clouds
        XCTAssert(clouds.coverage == 75)
        
        let atmo = weatherInfo.atmosphere
        XCTAssert(atmo.temperature == 14.48)
        XCTAssert(atmo.pressure == 1005)
        XCTAssert(atmo.humidity == 72)
        
    }
    
}

let sampleWeather = """
{"coord":{"lon":-0.13,"lat":51.51},"weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04d"}],"base":"stations","main":{"temp":14.48,"pressure":1005,"humidity":72,"temp_min":13,"temp_max":16.11},"visibility":10000,"wind":{"speed":4.1,"deg":240},"clouds":{"all":75},"dt":1570206744,"sys":{"type":1,"id":1414,"message":0.012,"country":"GB","sunrise":1570169116,"sunset":1570210395},"timezone":3600,"id":2643743,"name":"London","cod":200}
"""

let otherWeather = """
{"coord":{"lon":-75.43,"lat":2.89},"weather":[{"id":801,"main":"Clouds","description":"few clouds","icon":"02n"}],"base":"stations","main":{"temp":34,"pressure":1007,"humidity":38,"temp_min":34,"temp_max":34},"visibility":10000,"wind":{"speed":1.5},"clouds":{"all":20},"dt":1570490083,"sys":{"type":1,"id":8583,"message":0.0071,"country":"CO","sunrise":1570445234,"sunset":1570488702},"timezone":-18000,"id":3673286,"name":"Palermo","cod":200}
"""
