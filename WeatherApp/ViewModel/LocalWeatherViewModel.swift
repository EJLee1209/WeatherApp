//
//  LocalWeatherViewModel.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/15.
//

import RxSwift
import RxCocoa
import RxRelay
import Foundation
import CoreLocation

class LocalWeatherViewModel {
    
    let location: CLLocation
    let address : BehaviorRelay<String>
    let api: WeatherApiType
    let bag = DisposeBag()
    
    let weatherData = BehaviorRelay<WeatherDataType?>(value: nil)

    init(address: String, location: CLLocation, api: WeatherApiType) {
        self.address = .init(value: address)
        self.location = location
        self.api = api
        
        api.fetch(location: location)
            .compactMap { $0.0 }
            .bind(to: weatherData)
            .disposed(by: bag)
    }
}
