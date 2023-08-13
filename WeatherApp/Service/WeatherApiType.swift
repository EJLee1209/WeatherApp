//
//  WeatherApiType.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/13.
//

import Foundation
import CoreLocation
import RxSwift

protocol WeatherApiType {
    // 해당 장소의 날씨 데이터를 방출하는 옵저버블을 리턴 ( Observerable<(현재 날씨, 날씨 예보)> )
    @discardableResult
    func fetch(location: CLLocation) -> Observable<(WeatherDataType?, [WeatherDataType])>
}

extension WeatherApiType {
    func composeUrlRequest(endpoint: String, from location: CLLocation) -> Observable<URLRequest> {
        let urlStr = "\(endpoint)?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(Constants.apiKey)&lang=kr&units=metric"
        
        return Observable.just(urlStr)
            .compactMap { URL(string: $0) }
            .map { URLRequest(url: $0) }
    }    
}
