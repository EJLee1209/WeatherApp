//
//  WeatherData.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/13.
//

import Foundation
import RxCocoa
import RxDataSources

struct WeatherData: WeatherDataType, Equatable {
    var code: Int?
    var date: Date?
    var icon: String
    var description: String
    var temperature: Double
    var maxTemperature: Double?
    var minTemperature: Double?
    var pop: Double?
    
    var backgroundImageName: String {
        // 맑음(낮), 맑음(밤), 비, 눈
        let isNight = icon.contains("n") // 밤 or 낮
        
        guard let code else { return isNight ? "bg_clear_night" : "bg_clear" }
        
        switch code {
        case 200...599: // 비
            return isNight ? "bg_rain_night" : "bg_rain"
        case 600...699: // 눈
            return "bg_snow"
        case 700...799, 801...809: // 흐림
            return isNight ? "bg_cloud_night" : "bg_cloud"
        case 800: // 맑음
            return isNight ? "bg_clear_night" : "bg_clear"
            
        default:
            return isNight ? "bg_clear_night" : "bg_clear"
        }
    }
}

extension WeatherData {
    init(currentWeather: CurrentWeather) {
        code = currentWeather.weather.first?.id
        date = Date()
        icon = currentWeather.weather.first?.icon ?? ""
        description = currentWeather.weather.first?.description ?? "알 수 없음"
        temperature = currentWeather.main.temp
        maxTemperature = currentWeather.main.temp_max
        minTemperature = currentWeather.main.temp_min
        pop = nil
    }
    
    init(forecastItem: Forecast.ListItem) {
        date = Date(timeIntervalSince1970: TimeInterval(forecastItem.dt))
        icon = forecastItem.weather.first?.icon ?? ""
        description = forecastItem.weather.first?.description ?? "알 수 없음"
        temperature = forecastItem.main.temp
        maxTemperature = nil
        minTemperature = nil
        pop = forecastItem.pop
    }
    
    static func dailyWeatherData(data: [WeatherDataType], dateFormatter: DateFormatter) -> [WeatherDataType] {
        
        var dict : [String: [WeatherDataType]] = [:]
        
        dateFormatter.dateFormat = "yyyyMMdd"
        
        data.forEach { data in
            guard let date = data.date else { return }
            
            let dateKey = dateFormatter.string(from: date)
            
            if let _ = dict[dateKey] {
                dict[dateKey]!.append(data)
            } else {
                dict[dateKey] = [data]
            }
        }
        
        
        
        var dailyWeather: [WeatherDataType] = []
        
        for (_, values) in dict {
            var maxTemp = -Double(Int.max) // 최고 기온
            var minTemp = Double(Int.max) // 최저 기온
            
            var pop = 0.0 // 강수 확률
            
            values.forEach { data in
                maxTemp = max(maxTemp, data.temperature)
                minTemp = min(minTemp, data.temperature)
                if let rain = data.pop {
                    pop = max(pop, rain)
                }
            }
            
            let day = WeatherData(code: nil, date: values.first!.date!, icon: values.first!.icon, description: "", temperature: 0, maxTemperature: maxTemp, minTemperature: minTemp, pop: pop)
            
            dailyWeather.append(day)
        }
        
        dailyWeather.sort { $0.date! < $1.date! }
        
        return dailyWeather
    }
}

extension WeatherData: IdentifiableType {
    var identity: String {
        return UUID().uuidString
    }
}
