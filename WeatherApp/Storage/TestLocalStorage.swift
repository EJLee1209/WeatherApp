//
//  TestLocalStorage.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/15.
//

import Foundation
import RxSwift

class TestLocalStorage: LocalStorageType {
    
    private var list = [
        Local(address: "강남역", lat: 37.498206, lon: 127.02761),
        Local(address: "맨해튼", lat: 40.7830603, lon: -73.9712488)
    ]
    
    private lazy var sectionModel = LocalSectionModel(model: 0, items: list)
    
    private lazy var store = BehaviorSubject<[LocalSectionModel]>(value: [sectionModel])
    
    
    func create(address: String, lat: Double, lon: Double) -> RxSwift.Observable<Local> {
        let local = Local(address: address, lat: lat, lon: lon)
        sectionModel.items.insert(local, at: 0)
        
        store.onNext([sectionModel])
        
        return Observable.just(local)
    }
    
    func read() -> RxSwift.Observable<[LocalSectionModel]> {
        return store
    }
    
    func delete(local: Local) -> RxSwift.Observable<Local> {
        if let index = sectionModel.items.firstIndex(where: { $0 == local }) {
            sectionModel.items.remove(at: index)
        }
        
        store.onNext([sectionModel])
        
        return Observable.just(local)
    }
    
    
}
