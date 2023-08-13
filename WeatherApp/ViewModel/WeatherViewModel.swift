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
    
    var weatherData: Driver<[SectionModel]> {
        return locationProvider.currentLocation()
            .withUnretained(self)
            .flatMap { viewModel, location in
                viewModel.weatherApi.fetch(location: location)
                    .asDriver(onErrorJustReturn: (nil, [WeatherDataType]()))
            }
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
    
//    let dataSource: RxCollectionViewSectionedAnimatedDataSource<SectionModel> = {
//        let ds = RxCollectionViewSectionedAnimatedDataSource<SectionModel> { dataSource, collectionView, indexPath, data -> UICollectionViewCell in
//            
//            
//        }
//        
//        
//        return ds
//    }()
    
}
