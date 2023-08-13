//
//  SceneCoordinatorType.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/13.
//

import Foundation
import RxSwift

protocol SceneCoordinatorType {
    // 화면 전환 
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable
    
    // 이전 화면으로 복귀
    @discardableResult
    func close(animated: Bool) -> Completable
}
