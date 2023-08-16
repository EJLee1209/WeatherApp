//
//  Reactive+UINavigationItem.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/16.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UINavigationItem {
    var rightButtonIsHidden: Binder<Bool> {
        return Binder(self.base) { button, isHidden in
            if isHidden {
                button.setRightBarButton(nil, animated: false)
            }
        }
    }
}
