//
//  CoreDataManager.swift
//  weather-assessment
//
//  Created by Eugenio Baglieri on 06/10/2019.
//  Copyright © 2019 PED. All rights reserved.
//

import Foundation
import CoreData

enum StoreType {
    case binary
    case inMemory
    case sqlite
}

enum StoreLocation {
    case documents
    case caches
    case temporary
}

class CoreDataManager {
    
    enum ManagerError: Error {
        case storeUrlNotFound
        case unexistingModel
        case loadStoreError(Error)
    }
    
    private(set) static var `default`: CoreDataManager!
    
    let bundle: Bundle?
    
    let modelName: String
    
    private var _persistentContainer: NSPersistentContainer? = nil
    var persistentContainer: NSPersistentContainer {
        guard let container = _persistentContainer else {
            fatalError("Container not initialized. Call setup first")
        }
        return container
    }
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var privateContext: NSManagedObjectContext = {
        return persistentContainer.newBackgroundContext()
    }()
    
    private(set) lazy var backgroundContext: NSManagedObjectContext = {
        return persistentContainer.newBackgroundContext()
    }()
    
    init(modelName: String, bundle: Bundle? = nil)  {
        self.modelName = modelName
        self.bundle = bundle
    }
    
    func setup(storeType: StoreType = .sqlite, location: StoreLocation = .documents, bundle: Bundle? = nil, completionHandler: @escaping (ManagerError?) -> Void) {
        
        let bundle = bundle ?? .main
        
        guard let modelObjectUrl = bundle.url(forResource: modelName, withExtension: "momd"), let objectModel = NSManagedObjectModel(contentsOf: modelObjectUrl) else {
            completionHandler(ManagerError.unexistingModel)
            return
        }
        
        guard let storeDirectoryUrl = location.searchPathDirectory else {
            completionHandler(ManagerError.storeUrlNotFound)
            return
        }
        
        let storeUrl = storeDirectoryUrl.appendingPathComponent(modelName)
        let storeDescription = NSPersistentStoreDescription(url: storeUrl)
        storeDescription.type = storeType.persistentStoreType
        
        let container = NSPersistentContainer(name: modelName, managedObjectModel: objectModel)
        container.persistentStoreDescriptions = [storeDescription]
        container.loadPersistentStores { (_, error) in
            if let e = error {
                completionHandler(ManagerError.loadStoreError(e))
            } else {
                completionHandler(nil)
            }
        }
        
        _persistentContainer = container
    }
    
    func registerAsDefault() {
        CoreDataManager.default = self
    }
    
}

extension StoreLocation {
    var searchPathDirectory: URL? {
        let searchPath: FileManager.SearchPathDirectory
        switch self {
        case .documents:
            searchPath = FileManager.SearchPathDirectory.documentDirectory
        case .caches:
            searchPath = FileManager.SearchPathDirectory.cachesDirectory
        case .temporary:
            return FileManager.default.temporaryDirectory
        }
        
        let url = FileManager.default.urls(for: searchPath, in: .userDomainMask).first
        return url
    }
}

extension StoreType {
    
    var persistentStoreType: String {
        switch self {
        case .binary: return NSBinaryStoreType
        case .inMemory: return NSInMemoryStoreType
        case .sqlite: return NSSQLiteStoreType
        }
    }
    
}
