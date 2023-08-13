//
//  UIImage+Weather.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/13.
//

import UIKit

extension UIImage {
    static func from(name: String) -> UIImage? {
        if name.hasPrefix("01") {
            return UIImage(systemName: "sun.max")
        } else if name.hasPrefix("02") {
            return UIImage(systemName: "cloud.sun")
        } else if name.hasPrefix("03") || name.hasPrefix("04") {
            return UIImage(systemName: "cloud")
        } else if name.hasPrefix("09") {
            return UIImage(systemName: "cloud.heavyrain")
        } else if name.hasPrefix("10") {
            return UIImage(systemName: "cloud.rain")
        } else if name.hasPrefix("11") {
            return UIImage(systemName: "cloud.bolt")
        } else if name.hasPrefix("13") {
            return UIImage(systemName: "snow")
        } else if name.hasPrefix("30") {
            return UIImage(systemName: "sun.haze")
        }
        
        return UIImage(systemName: "questionmark")
    }
}
