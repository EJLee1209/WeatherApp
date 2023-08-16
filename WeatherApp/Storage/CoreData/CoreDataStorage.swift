//
//  CoreDataStorage.swift
//  WeatherApp
//
//  Created by 이은재 on 2023/08/16.
//

import Foundation
import RxSwift
import RxCoreData
import CoreData


class CoreDataStorage: LocalStorageType {
    let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    //MARK: - CRUD
    @discardableResult
    func create(address: String, lat: Double, lon: Double) -> RxSwift.Observable<Local> {
        let local = Local(address: address, lat: lat, lon: lon)
        
        do {
            _ = try mainContext.rx.update(local)
            return Observable.just(local)
        } catch {
            return Observable.error(error)
        }
    }
    
    @discardableResult
    func read() -> RxSwift.Observable<[LocalSectionModel]> {
        return mainContext.rx.entities(Local.self, sortDescriptors: [NSSortDescriptor(key: "insertDate", ascending: false)])
            .map { result in [LocalSectionModel(model: 0, items: result)] }
    }
    
    @discardableResult
    func delete(local: Local) -> RxSwift.Observable<Local> {
        do {
            try mainContext.rx.delete(local)
            
            return Observable.just(local)
        } catch {
            return Observable.error(error)
        }
    }
}
