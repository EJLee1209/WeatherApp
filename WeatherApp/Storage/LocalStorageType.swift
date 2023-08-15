//
//  LocalStorageType.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/15.
//

import Foundation
import RxSwift

//MARK: - CoreData CRUD

protocol LocalStorageType {
    
    @discardableResult
    func create(address: String, lat: Double, lon: Double) -> Observable<Local>
    
    @discardableResult
    func read() -> Observable<[LocalSectionModel]>
    
    @discardableResult
    func delegate(local: Local) -> Observable<Local>
}

