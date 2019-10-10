//
//  WeatherCellViewModel.swift
//  weather-assessment
//
//  Created by Eugenio Baglieri on 10/10/2019.
//  Copyright © 2019 PED. All rights reserved.
//

import Foundation

struct WeatherCellViewModel {
    
    private let kUnspecified = "--"
    
    let weatherInfo: WeatherInformation
    
    var cityName: String { return weatherInfo.cityName }
    
    var weatherDescription: String { return weatherInfo.weather.first?.description ?? kUnspecified}
    
    var weatherIconUrl: URL? {
        guard let iconName = weatherInfo.weather.first?.iconCode else {
            return nil
        }
        return Config.default.iconDownloadUrl.appendingPathComponent("\(iconName).@2x.png")
    }
    
    var temperature: String {
        let tempFormatter = MeasurementFormatter()
        tempFormatter.unitOptions = .temperatureWithoutUnit
        tempFormatter.numberFormatter = createIntegerNumberFormatter()
        let measure = Measurement(value: weatherInfo.atmosphere.temperature, unit: UnitTemperature.celsius)
        return tempFormatter.string(from: measure)
    }
    
    var pressure: String {
        let nf = createIntegerNumberFormatter()
        return nf.string(from: NSNumber(value: weatherInfo.atmosphere.pressure)) ?? kUnspecified
    }
    
    var humidity: String {
        let nf = createIntegerNumberFormatter()
        return nf.string(from: NSNumber(value: weatherInfo.atmosphere.humidity)) ?? kUnspecified
    }
    
    private func createIntegerNumberFormatter() -> NumberFormatter {
        let nf = NumberFormatter()
        nf.minimumFractionDigits = 0
        return nf
    }
}
