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
    let title = BehaviorRelay<String>(value: "")
    
    let sceneCoordinator: SceneCoordinatorType
    let weatherApi: WeatherApiType
    let locationProvider: LocationProviderType
    let localStorage: LocalStorageType
    
    init(
        title: String? = nil,
        sceneCoordinator: SceneCoordinatorType,
        weatherApi: WeatherApiType,
        locationProvider: LocationProviderType,
        storage: LocalStorageType
    ) {
        
        if let title = title {
            self.title.accept(title)
        }
        
        self.sceneCoordinator = sceneCoordinator
        self.weatherApi = weatherApi
        self.locationProvider = locationProvider
        self.localStorage = storage
        
        locationProvider.currentAddress()
            .bind(to: self.address)
            .disposed(by: bag)
    }
    
}
