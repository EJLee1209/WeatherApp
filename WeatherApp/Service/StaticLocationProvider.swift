//
//  StaticLocationProvider.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/13.
//

import Foundation
import RxSwift
import CoreLocation

class StaticLocationProvider: LocationProviderType {
    
    func reverseGeoCodeLocation(location: CLLocation) -> Observable<String> {
        return Observable.just("")
    }
    
    
    @discardableResult
    func currentLocation() -> Observable<CLLocation> {
        return Observable.just(CLLocation.gangnamStation)
    }
    
    @discardableResult
    func currentAddress() -> Observable<String> {
        return Observable.just("강남역")
    }
    
    
}
