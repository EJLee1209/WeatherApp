//
//  Scene.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/13.
//

import UIKit

enum Scene {
    case weather(WeatherViewModel)
    case searchLocation(SearchLocationViewModel)
}

extension Scene {
    func create() -> UIViewController {
        switch self {
        case .weather(let weatherViewModel):
            
            var vc = WeatherViewController()
            let nav = UINavigationController(rootViewController: vc)
            
            DispatchQueue.main.async {
                vc.bind(viewModel: weatherViewModel)
            }
            
            return nav
        case .searchLocation(let searchLocationViewModel):
            var vc = SearchLocationViewController()
            
            DispatchQueue.main.async {
                vc.bind(viewModel: searchLocationViewModel)
            }
            
            return vc
        }
    }

}
