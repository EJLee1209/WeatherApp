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

typealias SearchSectionModel = AnimatableSectionModel<Int, MKLocalSearchCompletion>

class SearchViewModel: CommonViewModel {
    
    let keyword = BehaviorRelay<String>(value: "") // 검색어
    
    var searchCompleter = MKLocalSearchCompleter() // 검색을 도와주는 변수
    
    let searchResults: BehaviorRelay<[SearchSectionModel]> = .init(value: []) // 검색 결과를 담을 변수
    
    override init(title: String? = nil, sceneCoordinator: SceneCoordinatorType, weatherApi: WeatherApiType, locationProvider: LocationProviderType) {
        super.init(title: title, sceneCoordinator: sceneCoordinator, weatherApi: weatherApi, locationProvider: locationProvider)
        
        searchCompleter.resultTypes = .address
        
        keyword
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(to: searchCompleter.rx.queryFragment)
            .disposed(by: bag)
        
        searchCompleter.rx.didUpdateResults
            .map { [SearchSectionModel(model: 0, items: $0)] }
            .bind(to: searchResults)
            .disposed(by: bag)
    }
    
    let dataSource: RxTableViewSectionedAnimatedDataSource<SearchSectionModel> = {
        
        let ds = RxTableViewSectionedAnimatedDataSource<SearchSectionModel> { dataSource, tableView, indexPath, data -> UITableViewCell in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
            cell.textLabel?.text = data.title
            return cell
        }
        
        return ds
    }()
    
    
    
}

extension MKLocalSearchCompletion: IdentifiableType {
    
    public var identity: String {
        return "\(self.title) \(self.subtitle)"
    }
    
}
