//
//  Local.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/15.
//

import Foundation
import RxDataSources
import CoreLocation

typealias LocalSectionModel = AnimatableSectionModel<Int, Local>

struct Local: Equatable  {
    let address: String
    let lat: Double
    let lon: Double
}

extension Local {
    
    var location: CLLocation {
        return CLLocation(latitude: self.lat, longitude: self.lon)
    }
    
}

extension Local: IdentifiableType {
    var identity: String {
        return "\(lat)+\(lon)+\(address)"
    }
}


