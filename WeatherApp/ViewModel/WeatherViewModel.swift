//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/13.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import UIKit
import Action
import CoreLocation


typealias SectionModel = AnimatableSectionModel<Int, WeatherData>

class WeatherViewModel: CommonViewModel {
    
    // 날씨 배경 이미지 이름 (Asset에 정의)
    var backgroundImageName = BehaviorRelay<String>(value: "bg_sunny")
    
    // location은 장소 검색 화면(SearchViewController)을 통해서만 주입
    // if location == nil, 현재 위치를 기반 날씨 else, 해당 위치를 기반 날씨
    var location: CLLocation?
    
    // location의 주소
    var locationAddress: BehaviorRelay<String> = .init(value: "")
    // 날씨 데이터, RxDataSource를 사용하기 위해서 SectionModel 사용
    var weatherData: BehaviorRelay<[SectionModel]> = .init(value: [SectionModel(model: 0, items: [])])
    
    init(
        title: String? = nil,
        location: CLLocation? = nil,
        sceneCoordinator: SceneCoordinatorType,
        weatherApi: WeatherApiType,
        locationProvider: LocationProviderType,
        storage: LocalStorageType
    ) {
        super.init(sceneCoordinator: sceneCoordinator, weatherApi: weatherApi, locationProvider: locationProvider, storage: storage)
        
        var observable: Observable<(WeatherDataType?, [WeatherDataType])>
        
        if let location {
            self.location = location
            
            // 주입 받은 location을 통해 reverseGeoCode를 하고, locationAddress에 바인딩
            locationProvider.reverseGeoCodeLocation(location: location)
                .bind(to: locationAddress)
                .disposed(by: bag)
            
            observable = weatherApi.fetch(location: location)
            
        } else {
            observable = locationProvider.currentLocation()
                .withUnretained(self)
                .flatMap { viewModel, location in
                    viewModel.weatherApi.fetch(location: location)
                        .asDriver(onErrorJustReturn: (nil, [WeatherDataType]()))
                }
        }
        
        observable
            .do(onNext: { [weak self] (weatherData, d) in

                guard let weatherData = weatherData else { return }
                // 날씨 데이터를 통해 배경 이미지 이름 요소 방출
                self?.backgroundImageName.accept(weatherData.backgroundImageName)
                
            })
            .compactMap { [weak self] (currentWeather, forecast) in
                return self?.makeSectionModelList(currentWeather: currentWeather, forecast: forecast)
            }
            .bind(to: weatherData)
            .disposed(by: bag)
    }
    
    var navBarButtonIsHidden: Driver<Bool> {
        
        guard let location = location else {
            return Observable.just(true)
                .asDriver(onErrorJustReturn: true)
        }
        
        return localStorage.read()
            .compactMap { $0.first?.items }
            .map { [weak self] locals in
                guard self != nil else { return true }
                
                return locals.contains { local in
                    local.location.coordinate.latitude == location.coordinate.latitude &&
                    local.location.coordinate.longitude == location.coordinate.longitude
                }
            }
            .asDriver(onErrorJustReturn: true)
    }
    
    
    static let tempFormatter: NumberFormatter = {
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        
        return formatter
    }()
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "Ko_kr")
        return formatter
    }()

    
    private func makeSectionModelList(currentWeather: WeatherDataType?, forecast: [WeatherDataType]) -> [SectionModel] {
        var currentWeatherList = [WeatherData]()
        
        var dailyWeather = WeatherData.dailyWeatherData(data: forecast, dateFormatter: WeatherViewModel.dateFormatter)
        
        if dailyWeather.count > 0 {
            dailyWeather.removeFirst()
        }
        
        if let currentWeather = currentWeather as? WeatherData {
            dailyWeather.insert(currentWeather, at: 0)
            
            currentWeatherList.append(currentWeather)
        }
        
        var forecast30Hour = [WeatherDataType]()
        
        if forecast.count > 10 {
            for i in 0...10 {
                forecast30Hour.append(forecast[i])
            }
        }
        
        return [
            SectionModel(model: 0, items: currentWeatherList), // 섹션 0, 현재 날씨
            SectionModel(model: 1, items: forecast30Hour as! [WeatherData]), // 섹션 1, 일기 예보(30시간, 3시간 간격)
            SectionModel(model: 2, items: dailyWeather as! [WeatherData]), // 섹션 2, 일기 예보(5일, 1일 간격)
        ]
    }
    
    // CollectionView RxDataSource
    lazy var dataSource: RxCollectionViewSectionedAnimatedDataSource<SectionModel> = {
        let ds = RxCollectionViewSectionedAnimatedDataSource<SectionModel>(configureCell: { dataSource, collectionView, indexPath, data -> UICollectionViewCell in
            
            // 섹션 분기 처리
            switch indexPath.section {
            case 0: // 섹션 0의 셀 정의
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentWeatherCell.identifier, for: indexPath) as! CurrentWeatherCell
                cell.configure(from: data, address: self.location == nil ? self.address.value : self.locationAddress.value, tempFormatter: WeatherViewModel.tempFormatter)
                return cell
                
            case 1: // 섹션 1의 셀 정의
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastHourlyCell.identifier, for: indexPath) as! ForecastHourlyCell
                cell.configure(data: data, dateFormatter: WeatherViewModel.dateFormatter, tempFormatter: WeatherViewModel.tempFormatter)
                return cell
                
            default: // 섹션 2의 셀 정의 or Another Section
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastDailyCell.identifier, for: indexPath) as! ForecastDailyCell
                cell.configure(data: data, dateFormatter: WeatherViewModel.dateFormatter, tempFormatter: WeatherViewModel.tempFormatter)
                return cell
            }
            
        }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath -> UICollectionReusableView in
            
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as! SectionHeaderView
                return header
            default:
                fatalError()
            }
            
        })
        
        
        return ds
    }()
    
    //MARK: - Action
    
    func makeLocationListButtonAction() -> CocoaAction {
        return CocoaAction { [weak self] _ in
            guard let self = self else { return Observable.empty() }
            let searchLocationViewModel = SearchViewModel(
                title: "날씨",
                sceneCoordinator: self.sceneCoordinator,
                weatherApi: self.weatherApi,
                locationProvider: self.locationProvider,
                storage: localStorage
            )
            
            let searchLocationScene = Scene.searchLocation(searchLocationViewModel)
            
            return self.sceneCoordinator.transition(to: searchLocationScene, using: .push, animated: true)
                .asObservable()
                .map { _ in }
                
        }
    }
    
    func makeAddButtonAction() -> CocoaAction {
        return CocoaAction { [weak self] _ in
            guard let self = self, let location = location else {
                return Observable.empty()
            }
            
            return localStorage.create(address: locationAddress.value, lat: location.coordinate.latitude, lon: location.coordinate.longitude)
                .flatMap { _ in
                    self.sceneCoordinator.close(animated: true)
                        .asObservable()
                        .map { _ in }
                }
        }
    }
    
    func makeCancelButtonAction() -> CocoaAction {
        return CocoaAction { [weak self] _ in
            guard let self = self else {
                return Observable.empty()
            }
            
            return self.sceneCoordinator.close(animated: true)
                .asObservable()
                .map { _ in }
        }
    }
    
}
