//
//  WeatherCellViewModel.swift
//  weather-assessment
//
//  Created by Eugenio Baglieri on 10/10/2019.
//  Copyright © 2019 PED. All rights reserved.
//

import UIKit

class WeatherCellViewModel {
    
    private let kUnspecified = "--"
    
    let weatherInfo: WeatherInformation
    
    var cityName: String { return weatherInfo.cityName }
    
    var isContentExpanded = false
    
    var backgroundColor: UIColor? = nil
    
    var weatherDescription: String { return weatherInfo.weather.first?.description ?? kUnspecified}
    
    var weatherIconUrl: URL? {
        guard let iconName = weatherInfo.weather.first?.iconCode else {
            return nil
        }
        return Config.default.iconDownloadUrl.appendingPathComponent("\(iconName)@2x.png")
    }
    
    var temperature: String {
        let tempFormatter = MeasurementFormatter()
        tempFormatter.unitOptions = .temperatureWithoutUnit
        tempFormatter.numberFormatter = createIntegerNumberFormatter()
        let measure = Measurement(value: weatherInfo.atmosphere.temperature, unit: UnitTemperature.celsius)
        return tempFormatter.string(from: measure)
    }
    
    var pressure: String {
        let pressureFormatter = MeasurementFormatter()
        pressureFormatter.numberFormatter = createIntegerNumberFormatter()
        pressureFormatter.unitOptions = .providedUnit
        let measure = Measurement(value: weatherInfo.atmosphere.pressure, unit: UnitPressure.hectopascals)
        return pressureFormatter.string(from: measure)
    }
    
    var humidity: String {
        let nf = createIntegerNumberFormatter()
        return (nf.string(from: NSNumber(value: weatherInfo.atmosphere.humidity)) ?? kUnspecified) + "%"
    }
    
    private func createIntegerNumberFormatter() -> NumberFormatter {
        let nf = NumberFormatter()
        nf.minimumFractionDigits = 0
        return nf
    }
    
    init(weatherInfo: WeatherInformation) {
        self.weatherInfo = weatherInfo
    }
}
