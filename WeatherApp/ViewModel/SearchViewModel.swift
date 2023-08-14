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
    
    let selectedItem = PublishRelay<MKLocalSearchCompletion>()
    let selectedLocation = PublishRelay<CLLocation>()
    
    override init(title: String? = nil, sceneCoordinator: SceneCoordinatorType, weatherApi: WeatherApiType, locationProvider: LocationProviderType) {
        super.init(title: title, sceneCoordinator: sceneCoordinator, weatherApi: weatherApi, locationProvider: locationProvider)
        
        searchCompleter.resultTypes = .address
        
        keyword
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance) // 1초에 한번씩만
            .bind(to: searchCompleter.rx.queryFragment)
            .disposed(by: bag)
        
        searchCompleter.rx.didUpdateResults
            .map { [SearchSectionModel(model: 0, items: $0)] }
            .bind(to: searchResults)
            .disposed(by: bag)
        
        selectedItem
            .subscribe(onNext: { [weak self] item in
                self?.search(for: item)
            })
            .disposed(by: bag)
        
        selectedLocation
            .subscribe(onNext: { [weak self] location in
                self?.makeWeatherModalViewFromSelectedItem(location: location)
            })
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
    
    private func search(for suggestedCompletion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: suggestedCompletion)
        
        search(using: searchRequest)
            .bind(to: selectedLocation)
            .disposed(by: bag)
    }
    
    private func search(using searchRequest: MKLocalSearch.Request) -> Observable<CLLocation> {
        // 검색 지역 설정
        searchRequest.region = MKCoordinateRegion(.world)
        
        // 검색 유형 설정
        searchRequest.resultTypes = .address
        // MKLocalSearch 생성
        let localSearch = MKLocalSearch(request: searchRequest)
        
        return Observable.create { observer in
            
            // 비동기로 검색 실행
            localSearch.start { (response, error) in
                guard error == nil else {
                    return
                }
                // 검색한 결과 : reponse의 mapItems 값을 가져온다.
                guard let coord = response?.mapItems[0].placemark.coordinate else {
                    observer.onNext(CLLocation.gangnamStation)
                    return
                }
                
                let location = CLLocation(latitude: coord.latitude, longitude: coord.longitude)
                
                observer.onNext(location)
                
                observer.onCompleted()
            }
            
            return Disposables.create()
            
        }
        
    }
    
    private func makeWeatherModalViewFromSelectedItem(location: CLLocation) {
        let weatherViewModel = WeatherViewModel(location: location, sceneCoordinator: sceneCoordinator, weatherApi: weatherApi, locationProvider: locationProvider)
        let weatherScene = Scene.weather(weatherViewModel)
        
        sceneCoordinator.transition(to: weatherScene, using: .modal, animated: true)
    }
    
}

