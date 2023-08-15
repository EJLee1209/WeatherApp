//
//  WeatherApi.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/13.
//

import Foundation
import RxSwift
import CoreLocation
import RxCocoa

class WeatherApi: WeatherApiType {
    
    private let currentRelay = BehaviorRelay<WeatherDataType?>(value: nil)
    private let forecastRelay = BehaviorRelay<[WeatherDataType]>(value: [])
    
    private let bag = DisposeBag()
    
    private func fetchCurrentWeather(location: CLLocation) -> Observable<WeatherDataType?> {
        composeUrlRequest(endpoint: Constants.currentWeatherEndpoint, from: location)
            .flatMap { URLSession.shared.rx.data(request: $0) }
            .map { data -> WeatherData in
                let weather = try JSONDecoder().decode(CurrentWeather.self, from: data)
                return WeatherData(currentWeather: weather)
            }
            .catchAndReturn(nil)
    }
    
    private func fetchForecast(location: CLLocation) -> Observable<[WeatherDataType]> {
        composeUrlRequest(endpoint: Constants.forecastEndpoint, from: location)
            .flatMap { URLSession.shared.rx.data(request: $0) }
            .map { data -> [WeatherData] in
                let forecast = try JSONDecoder().decode(Forecast.self, from: data)
                return forecast.list.map(WeatherData.init)
            }
            .catchAndReturn([])
        
    }
    
    func fetch(location: CLLocation) -> Observable<(WeatherDataType?, [WeatherDataType])> {
        let currentWeather = fetchCurrentWeather(location: location)
        let forecast = fetchForecast(location: location)
        
        return Observable.zip(currentWeather, forecast)
    }
}
