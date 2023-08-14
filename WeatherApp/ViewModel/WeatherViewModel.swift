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


typealias SectionModel = AnimatableSectionModel<Int, WeatherData>

class WeatherViewModel: CommonViewModel {
    
    // 날씨 배경 이미지 이름 (Asset에 정의)
    var backgroundImageName = BehaviorRelay<String>(value: "bg_sunny")
    
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
    
    // 날씨 데이터, RxDataSource를 사용하기 위해서 SectionModel 사용
    var weatherData: Driver<[SectionModel]> {
        return locationProvider.currentLocation()
            .withUnretained(self)
            .flatMap { viewModel, location in
                viewModel.weatherApi.fetch(location: location)
                    .asDriver(onErrorJustReturn: (nil, [WeatherDataType]()))
            }
            .do(onNext: { [weak self] (weatherData, d) in
                
                guard let weatherData = weatherData else { return }
                // 날씨 데이터를 통해 배경 이미지 이름 요소 방출
                self?.backgroundImageName.accept(weatherData.backgroundImageName)
                
            })
            .compactMap { [weak self] (currentWeather, forecast) in
                return self?.makeSectionModelList(currentWeather: currentWeather, forecast: forecast)
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeSectionModelList(currentWeather: WeatherDataType?, forecast: [WeatherDataType]) -> [SectionModel] {
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
                cell.configure(from: data, address: self.address.value, tempFormatter: WeatherViewModel.tempFormatter)
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
            let searchLocationViewModel = SearchLocationViewModel(
                title: "날씨",
                sceneCoordinator: self.sceneCoordinator,
                weatherApi: self.weatherApi,
                locationProvider: self.locationProvider
            )
            
            let searchLocationScene = Scene.searchLocation(searchLocationViewModel)
            
            return self.sceneCoordinator.transition(to: searchLocationScene, using: .push, animated: true)
                .asObservable()
                .map { _ in }
                
        }
    }
    
}
