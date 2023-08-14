//
//  SearchLocationViewModel.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/13.
//

import Foundation
import RxSwift
import RxCocoa
import MapKit
import RxDataSources

class SearchViewModel: CommonViewModel {
    
    let keyword = BehaviorRelay<String>(value: "") // 검색어
    
    var searchCompleter = MKLocalSearchCompleter() // 검색을 도와주는 변수
    
    let results: BehaviorRelay<[MKLocalSearchCompletion]> = .init(value: []) // 검색 결과를 담을 변수
    
    override init(title: String? = nil, sceneCoordinator: SceneCoordinatorType, weatherApi: WeatherApiType, locationProvider: LocationProviderType) {
        super.init(title: title, sceneCoordinator: sceneCoordinator, weatherApi: weatherApi, locationProvider: locationProvider)
        
        searchCompleter.resultTypes = .address
        keyword.bind(to: searchCompleter.rx.queryFragment)
            .disposed(by: bag)
        
        searchCompleter.rx.didUpdateResults
            .bind(to: results)
            .disposed(by: bag)
        
    }
    
    
    
}



