//
//  WeatherDataProvider.swift
//  weather-assessment
//
//  Created by Eugenio Baglieri on 08/10/2019.
//  Copyright © 2019 PED. All rights reserved.
//

import Foundation
import CoreData

typealias WeatherDataProviderResult = Result<WeatherInformation, WeatherRequestError>
typealias WeatherDataProviderCompletionHandler = (Result<WeatherInformation, WeatherRequestError>) -> Void

class WeatherDataProvider {
    
    let persistentContainer: NSPersistentContainer
    
    private let expiringTimeInterval: TimeInterval
    
    private var currentRequest: WeatherRequest?
    
    //Default expiring time 1 hour
    init(persistentContainer: NSPersistentContainer, expiringTimeInterval: TimeInterval = 3600) {
        self.persistentContainer = persistentContainer
        self.expiringTimeInterval = expiringTimeInterval
    }
    
    func fetchWeatherForCityWithName(_ city: String, completion: @escaping WeatherDataProviderCompletionHandler) {
        currentRequest?.cancel()
        var didFoundCachedResult = false
        let matchingFetchRequest = createFetchRequest(city: city)
        let context = persistentContainer.newBackgroundContext()
        context.performAndWait {
            let results = try? context.fetch(matchingFetchRequest)
            if let weatherInfo = results?.first?.weatherInformation() {
                didFoundCachedResult = true
                DispatchQueue.main.async {
                    completion(.success(weatherInfo))
                }
            }
        }
        
        guard didFoundCachedResult == false else { return }
        
        currentRequest = WeatherRequest(city: city, completionHandler: { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let weatherInfo):
                _ = strongSelf.syncWeatherInformation(weatherInfo, for: city)
                DispatchQueue.main.async {
                    completion(.success(weatherInfo))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        })
        currentRequest!.run()
    }
    
    func createFetchRequest(city: String) -> NSFetchRequest<CachedWeather> {
        let cityNamePredicate = NSPredicate(format: "city ==[c] '\(city)'")
        let notExpiredPredicate = NSPredicate(format: "expiringTime > \(NSNumber(value: Date().timeIntervalSince1970))")
        let sortDescriptor = NSSortDescriptor(key: "expiringTime", ascending: false)
        let fr: NSFetchRequest<CachedWeather> = CachedWeather.fetchRequest()
        fr.fetchLimit = 1
        fr.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [cityNamePredicate, notExpiredPredicate])
        fr.sortDescriptors = [sortDescriptor]
        
        return fr
    }
    
    private func syncWeatherInformation(_ weatherInfo: WeatherInformation, for city: String) -> Bool {
        let syncContext = persistentContainer.newBackgroundContext()
        let _expiringTimeInterval = expiringTimeInterval
        var success: Bool = false
        syncContext.performAndWait { [unowned syncContext] in
            let predicate = NSPredicate(format: "city ==[c] '\(city)'", city)
            let fr: NSFetchRequest<NSFetchRequestResult> = CachedWeather.fetchRequest()
            fr.predicate = predicate
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fr)
            do {
                try syncContext.execute(deleteRequest)
                let cached = CachedWeather(context: syncContext)
                cached.city = city
                cached.expiringTime = Date().timeIntervalSince1970 + _expiringTimeInterval
                cached.data = try! JSONEncoder().encode(weatherInfo)
            } catch let error {
                print("Could not delete existing records: \(error)")
                return
            }
            syncContext.saveToPersistentStore { (error) in
                if error != nil {
                    print("Could not save: \(error!)")
                    return
                }
            }
        }
        
        success = true
        return success
    }
}
