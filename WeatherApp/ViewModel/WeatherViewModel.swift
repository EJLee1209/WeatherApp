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
    
    var weatherData: Driver<[SectionModel]> {
        return locationProvider.currentLocation()
            .withUnretained(self)
            .flatMap { viewModel, location in
                viewModel.weatherApi.fetch(location: location)
                    .asDriver(onErrorJustReturn: (nil, [WeatherDataType]()))
            }
            .do(onNext: { [weak self] (weatherData, _) in
                
                guard let weatherData = weatherData else { return }
                self?.backgroundImageName.accept(weatherData.backgroundImageName)
                
            })
            .map { (summary, forecast) in
                var summaryList = [WeatherData]()
                
                if let summary = summary as? WeatherData {
                    summaryList.append(summary)
                }
                
                return [
                    SectionModel(model: 0, items: summaryList),
                    SectionModel(model: 1, items: forecast as! [WeatherData]),
                    SectionModel(model: 2, items: forecast as! [WeatherData]),
                ]
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    lazy var dataSource: RxCollectionViewSectionedAnimatedDataSource<SectionModel> = {
        let ds = RxCollectionViewSectionedAnimatedDataSource<SectionModel> { dataSource, collectionView, indexPath, data -> UICollectionViewCell in
            
            // 섹션 분기 처리
            switch indexPath.section {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentWeatherCell.identifier, for: indexPath) as! CurrentWeatherCell
                cell.configure(from: data, address: self.address.value, tempFormatter: WeatherViewModel.tempFormatter)
                return cell
                
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastHourlyCell.identifier, for: indexPath) as! ForecastHourlyCell
                cell.configure(data: data, dateFormatter: WeatherViewModel.dateFormatter, tempFormatter: WeatherViewModel.tempFormatter)
                return cell
                
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastDailyCell.identifier, for: indexPath) as! ForecastDailyCell
                cell.configure(data: data, dateFormatter: WeatherViewModel.dateFormatter, tempFormatter: WeatherViewModel.tempFormatter)
                return cell
            }
            
        }
        
        
        return ds
    }()
    
}
