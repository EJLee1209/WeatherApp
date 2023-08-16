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
import Action

typealias SearchSectionModel = AnimatableSectionModel<Int, MKLocalSearchCompletion>

class SearchViewModel: CommonViewModel {
    
    let keyword = BehaviorRelay<String>(value: "") // 검색어
    
    var searchCompleter = MKLocalSearchCompleter() // 검색을 도와주는 변수
    
    let searchResults: BehaviorRelay<[SearchSectionModel]> = .init(value: []) // 검색 결과를 담을 변수
    
    let selectedItem = PublishRelay<MKLocalSearchCompletion>() // 선택한 Cell item
    let selectedLocation = PublishRelay<CLLocation>() // 선택한 Cell의 위치 정보
    
    let localList = BehaviorRelay<[LocalSectionModel]>(value: []) // CoreData에 저장된 지역 데이터
    
    override init(title: String? = nil, sceneCoordinator: SceneCoordinatorType, weatherApi: WeatherApiType, locationProvider: LocationProviderType, storage: LocalStorageType) {
        super.init(title: title, sceneCoordinator: sceneCoordinator, weatherApi: weatherApi, locationProvider: locationProvider, storage: storage)
        
        searchCompleter.resultTypes = .address
        
        // 키워드 바인딩
        keyword
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance) // 1초에 한번씩만
            .bind(to: searchCompleter.rx.queryFragment)
            .disposed(by: bag)
        
        // 장소 검색 결과 바인딩
        searchCompleter.rx.didUpdateResults
            .map { [SearchSectionModel(model: 0, items: $0)] }
            .bind(to: searchResults)
            .disposed(by: bag)
        
        // 선택된 Cell item 방출시 search 메소드 호출 (위치 정보 요청)
        selectedItem
            .subscribe(onNext: { [weak self] item in
                self?.search(for: item)
            })
            .disposed(by: bag)
        
        // 선택된 Cell의 위치 데이터 방출(위치 정보 요청에 대한 응답 방출) 시 해당 위치의 날씨 화면을 보여주는 메소드 호출
        selectedLocation
            .subscribe(onNext: { [weak self] location in
                self?.makeWeatherModalViewFromSelectedItem(location: location)
            })
            .disposed(by: bag)
        
        // 지역 데이터 읽어오기
        localStorage.read()
            .bind(to: self.localList)
            .disposed(by: bag)
    }
    
    // Coredata에 저장되어 있는 지역 정보 CollectionView에 사용할 RxDataSource
    lazy var localDataSource: RxTableViewSectionedAnimatedDataSource<LocalSectionModel> = {
        let ds = RxTableViewSectionedAnimatedDataSource<LocalSectionModel> { dataSource, collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withIdentifier: LocalWeatherCell.identifier, for: indexPath) as! LocalWeatherCell
            cell.viewModel = LocalWeatherViewModel(address: item.address, location: item.location, api: self.weatherApi)
            
            return cell
        }
        
        ds.canEditRowAtIndexPath = { _,_ in return true }
        return ds
    }()
    
    // 검색 결과 TableView에 사용할 RxDataSource
    let dataSource: RxTableViewSectionedAnimatedDataSource<SearchSectionModel> = {
        
        let ds = RxTableViewSectionedAnimatedDataSource<SearchSectionModel> { dataSource, tableView, indexPath, data -> UITableViewCell in
            
            // 단일 섹션이라 섹션 분기 처리 필요 없음
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath)
            cell.textLabel?.text = data.title
            return cell
            
        }
        
        return ds
    }()
    
    // 검색 결과 item을 토대로 위치 정보를 요청하는 메소드
    private func search(for suggestedCompletion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: suggestedCompletion)
        
        // 위치 정보 응답을 방출하는 Observable을 selectedLocation에 바인딩
        search(using: searchRequest)
            .bind(to: selectedLocation)
            .disposed(by: bag)
    }
    
    // 요청한 위치 정보의 응답을 방출하는 Observable 리턴
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
    
    // 위치 정보 응답 발생시 호출되며, location 정보로 날씨 예보 화면을 보여줌
    private func makeWeatherModalViewFromSelectedItem(location: CLLocation) {
        let weatherViewModel = WeatherViewModel(location: location, sceneCoordinator: sceneCoordinator, weatherApi: weatherApi, locationProvider: locationProvider, storage: localStorage)
        let weatherScene = Scene.weather(weatherViewModel)
        
        sceneCoordinator.transition(to: weatherScene, using: .modal, animated: true)
    }
    
    
    //MARK: - Actions
    
    lazy var deleteAction: Action<Local, Void> = {
        return Action { [weak self] local in
            guard let self = self else { return Observable.empty() }
            
            return localStorage.delete(local: local)
                .map { _ in }
        }
    }()
}

