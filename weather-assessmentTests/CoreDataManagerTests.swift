//
//  CoreDataManagerTests.swift
//  weather-assessmentTests
//
//  Created by Eugenio Baglieri on 06/10/2019.
//  Copyright © 2019 PED. All rights reserved.
//

import XCTest
import CoreData
@testable import weather_assessment

class CoreDataManagerTests: XCTestCase {

    let thisBundle = Bundle(for: CoreDataManagerTests.self)
    
    var manager: CoreDataManager!
    
    override func setUp() {
           manager = CoreDataManager(modelName: "weather_assessment", bundle: thisBundle)
       }
    
    func test_WhenGivenUnexistingModelName_ReturnsError() {
        let exp = XCTestExpectation(description: "Setup finished")
        manager = CoreDataManager(modelName: "notExistingName", bundle: thisBundle)
        manager.setup { (error) in
            XCTAssertNotNil(error)
            if case CoreDataManager.ManagerError.unexistingModel = error! {
                XCTAssert(true)
            } else {
                XCTFail()
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
    }
    
    func test_WhenGivenExistingModelName_ReturnNoError() {
        let exp = XCTestExpectation(description: "Setup finished")
        manager.setup { (error) in
            XCTAssertNil(error)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
    }
    
    func test_WhenRegisteredAsDefault_IsReturnedInDefaultProprty() {
        let exp = XCTestExpectation(description: "Setup finished")
       manager.setup { (_) in
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
        
        manager.registerAsDefault()
        XCTAssertTrue(CoreDataManager.default === manager)
    }
    
    func test_StoreTypeAndStoreLocation() {
        let exp = XCTestExpectation(description: "Setup finished")
        manager.setup(storeType: .inMemory, location: .caches, bundle: thisBundle) { (error) in
            XCTAssertNil(error)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
        
        XCTAssertNotNil(manager.persistentContainer.persistentStoreDescriptions.first)
        let storeDescription = manager.persistentContainer.persistentStoreDescriptions.first!
        
        XCTAssertNotNil(storeDescription.url)
        XCTAssertTrue(storeDescription.url == (StoreLocation.caches.searchPathDirectory)?.appendingPathComponent(manager.modelName))
        XCTAssertTrue(storeDescription.type == StoreType.inMemory.persistentStoreType)
    }
    
    func test_ViewContextIsAlwaysOnMainThread() {
        let exp = XCTestExpectation(description: "Setup finished")
        manager.setup { (_) in
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 2)
        XCTAssertTrue(manager.persistentContainer.viewContext == manager.viewContext)
    }

}
