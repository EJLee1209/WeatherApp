//
//  LocationProviderType.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/13.
//

import Foundation
import CoreLocation
import RxSwift

protocol LocationProviderType {
    
    // 현재 위치를 방출하는 옵저버블을 리턴
    @discardableResult
    func currentLocation() -> Observable<CLLocation>
    
    // 위도, 경도를 통해 현재 주소를 문자열 형태로 방출하는 옵저버블을 리턴
    @discardableResult
    func currentAddress() -> Observable<String>
    
}
