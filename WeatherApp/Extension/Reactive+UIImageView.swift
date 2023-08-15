//
//  Reactive+UIImage.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/14.
//

import Foundation
import RxSwift
import UIKit

extension Reactive where Base: UIImageView {
    
    var background: Binder<String> {
        return Binder(self.base) { iv, imageName in
            iv.image = UIImage(named: imageName)
        }
    }
}

extension Reactive where Base: UIImageView {
    
    var cellBackground: Binder<WeatherDataType> {
        return Binder(self.base) { iv, data in
            iv.image = UIImage(named: data.backgroundImageName)
        }
    }
    
}
