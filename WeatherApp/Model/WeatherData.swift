//
//  WeatherData.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/13.
//

import Foundation
import RxCocoa
import RxDataSources

struct WeatherData: WeatherDataType {
    var date: Date?
    var icon: String
    var description: String
    var temperature: Double
    var maxTemperature: Double?
    var minTemperature: Double?
}

extension WeatherData {
    init(currentWeather: CurrentWeather) {
        date = Date()
        icon = currentWeather.weather.first?.icon ?? ""
        description = currentWeather.weather.first?.description ?? "알 수 없음"
        temperature = currentWeather.main.temp
        maxTemperature = currentWeather.main.temp_max
        minTemperature = currentWeather.main.temp_min
    }
    
    init(forecastItem: Forecast.ListItem) {
        date = Date(timeIntervalSince1970: TimeInterval(forecastItem.dt))
        icon = forecastItem.weather.first?.icon ?? ""
        description = forecastItem.weather.first?.description ?? "알 수 없음"
        temperature = forecastItem.main.temp
        maxTemperature = nil
        minTemperature = nil
    }
}

extension WeatherData: IdentifiableType {
    var identity: Double {
        return date?.timeIntervalSinceReferenceDate ?? 0
    }
}
