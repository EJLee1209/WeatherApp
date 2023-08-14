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
            .do(onNext: { [weak self] (weatherData, _) in
                
                guard let weatherData = weatherData else { return }
                // 날씨 데이터를 통해 배경 이미지 이름 요소 방출
                self?.backgroundImageName.accept(weatherData.backgroundImageName)
                
            })
            .map { (currentWeather, forecast) in
                var currentWeatherList = [WeatherData]()
                
                if let currentWeather = currentWeather as? WeatherData {
                    currentWeatherList.append(currentWeather)
                }
                
                let dailyWeather = WeatherData.dailyWeatherData(data: forecast, dateFormatter: WeatherViewModel.dateFormatter)
                
                return [
                    SectionModel(model: 0, items: currentWeatherList), // 섹션 0, 현재 날씨
                    SectionModel(model: 1, items: forecast as! [WeatherData]), // 섹션 1, 일기 예보(5일, 3시간 간격)
                    SectionModel(model: 2, items: dailyWeather as! [WeatherData]), // 섹션 2, 일기 예보(5일, 1일 간격)
                ]
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    // CollectionView RxDataSource
    lazy var dataSource: RxCollectionViewSectionedAnimatedDataSource<SectionModel> = {
        let ds = RxCollectionViewSectionedAnimatedDataSource<SectionModel> { dataSource, collectionView, indexPath, data -> UICollectionViewCell in
            
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
            
        }
        
        
        return ds
    }()
    
}
