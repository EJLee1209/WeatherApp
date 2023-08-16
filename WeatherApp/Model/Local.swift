//
//  Local.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/15.
//

import Foundation
import RxDataSources
import CoreLocation
import RxCoreData
import CoreData

typealias LocalSectionModel = AnimatableSectionModel<Int, Local>

struct Local: Equatable, IdentifiableType  {
    let address: String
    let lat: Double
    let lon: Double
    let insertDate: Date
    var identity: String
    
    
    init(address: String, lat: Double, lon: Double, insertDate: Date = Date()) {
        self.address = address
        self.lat = lat
        self.lon = lon
        self.insertDate = insertDate
        self.identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
}

extension Local {
    
    var location: CLLocation {
        return CLLocation(latitude: self.lat, longitude: self.lon)
    }
    
}

extension Local: Persistable {
    
    static var entityName: String {
        return "Local"
    }
    
    static var primaryAttributeName: String {
        return "identity" // pk 속성 이름
    }
    
    init(entity: NSManagedObject) {
        address = entity.value(forKey: "address") as! String
        lat = entity.value(forKey: "lat") as! Double
        lon = entity.value(forKey: "lon") as! Double
        insertDate = entity.value(forKey: "insertDate") as! Date
        identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
    
    func update(_ entity: NSManagedObject) {
        entity.setValue(address, forKey: "address")
        entity.setValue(lat, forKey: "lat")
        entity.setValue(lon, forKey: "lon")
        entity.setValue(insertDate, forKey: "insertDate")
        entity.setValue("\(insertDate.timeIntervalSinceReferenceDate)", forKey: "identity")
        
        do {
            try entity.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
    
}
