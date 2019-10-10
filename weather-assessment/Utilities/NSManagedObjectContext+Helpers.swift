//
//  NSManagedObjectContext+Helpers.swift
//  weather-assessment
//
//  Created by Eugenio Baglieri on 07/10/2019.
//  Copyright © 2019 PED. All rights reserved.
//

import CoreData

public typealias EmptyCoreDataCompletion = (Error?) -> ()

extension NSManagedObjectContext {
    
    func saveToPersistentStore(withCompletionHandler completionHandler: EmptyCoreDataCompletion?) {
        if !self.hasChanges {
            NSLog("Skipping saving operation, no changes in context.")
            completionHandler?(nil)
            return
        }
        
        do {
            try self.save()
            if let parent = self.parent {
                parent.performAndWait {
                    parent.saveToPersistentStore(withCompletionHandler: completionHandler)
                }
            } else {
                completionHandler?(nil)
            }
        } catch let error as NSError {
            NSLog("\(error)")
            completionHandler?(error)
        }
    }
    
}
