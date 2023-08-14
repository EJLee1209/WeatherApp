//
//  SearchLocationViewModel.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/13.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel: CommonViewModel {
    
    let keyword = BehaviorRelay<String>(value: "")
    
}
