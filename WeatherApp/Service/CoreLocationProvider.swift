//
//  CoreLocationProvider.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/14.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa

class CoreLocationProvider: LocationProviderType {
    
    private let locationManager = CLLocationManager()
    
    private let location = BehaviorRelay(value: CLLocation.gangnamStation)
    
    private let address = BehaviorRelay(value: "강남역")
    
    private let authorized = BehaviorRelay(value: false)
    
    private let bag = DisposeBag()
    
    init() {
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.pausesLocationUpdatesAutomatically = false
        
        locationManager.rx.didUpdateLocation
            .throttle(.seconds(60), scheduler: MainScheduler.instance) // 위치 정보 업데이트를 60초 주기로 제한
            .map { $0.last ?? CLLocation.gangnamStation }
            .bind(to: location)
            .disposed(by: bag)
        
        location.flatMap { location in
            return Observable<String>.create { observer in
                let geocoder = CLGeocoder()
                geocoder.reverseGeocodeLocation(location) { placemarks, error in
                    if let place = placemarks?.first {
                        if let gu = place.locality, let dong = place.subLocality {
                            observer.onNext("\(gu) \(dong)")
                        } else {
                            observer.onNext(place.name ?? "알 수 없음")
                        }
                    } else {
                        observer.onNext("알 수 없음")
                    }
                    
                    observer.onCompleted()
                }
                
                return Disposables.create()
            }
        }
        .bind(to: address)
        .disposed(by: bag)
        
    }
    
    @discardableResult
    func currentLocation() -> Observable<CLLocation> {
        return location.asObservable()
    }
    
    @discardableResult
    func currentAddress() -> Observable<String> {
        return address.asObservable()
    }
    
    
}
