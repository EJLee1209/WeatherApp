//
//  TransitionModel.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/13.
//

import Foundation

enum TransitionStyle {
    case root
    case push
    case modal
}

enum TransitionError: Error {
    case navigationControllerMissing
    case cannotPop
    case unknown
}
