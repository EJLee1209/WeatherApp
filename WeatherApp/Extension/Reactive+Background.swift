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
