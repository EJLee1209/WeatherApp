//
//  Reactive+UILabel.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/16.
//

import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UILabel {
    
    var description: Binder<WeatherDataType> {
        return Binder(self.base) { label, data in
            label.text = data.description
        }
    }
    
    var temperature: Binder<WeatherDataType> {
        return Binder(self.base) { label, data in
            label.text = "\(Int(data.temperature))°"
        }
    }
    
    var minMaxTemp: Binder<WeatherDataType> {
        return Binder(self.base) { label, data in
            let max = data.maxTemperature ?? 0.0
            let min = data.minTemperature ?? 0.0
    
            let maxTemp = WeatherViewModel.tempFormatter.string(for: max) ?? "-"
            let minTemp = WeatherViewModel.tempFormatter.string(for: min) ?? "-"
            
            let maxMinTemp = "최고:\(maxTemp)° 최저:\(minTemp)°"
            
            label.text = maxMinTemp
        }
    }
    
}
