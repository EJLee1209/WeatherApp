//
//  CommonViewModel.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/13.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay

class CommonViewModel: NSObject {
    
    let bag = DisposeBag()
    let address = BehaviorRelay<String>(value: "")
    
    let sceneCoordinator: SceneCoordinatorType
    let weatherApi: WeatherApiType
    let locationProvider: LocationProviderType
    
    init(sceneCoordinator: SceneCoordinatorType, weatherApi: WeatherApiType, locationProvider: LocationProviderType) {
        self.sceneCoordinator = sceneCoordinator
        self.weatherApi = weatherApi
        self.locationProvider = locationProvider
        
        locationProvider.currentAddress()
            .bind(to: self.address)
            .disposed(by: bag)
    }
    
}
