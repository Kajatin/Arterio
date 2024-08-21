//
//  HealthKitManager.swift
//  Arterio
//
//  Created by Roland Kajatin on 13/08/2024.
//

import Foundation
import HealthKit

@Observable
class HealthKitManager {
    var healthStore: HKHealthStore?
    var authorizationStatus = HKAuthorizationStatus.notDetermined
    var error: HKError?
    
    init() {
        if HKHealthStore.isHealthDataAvailable() {
            healthStore = HKHealthStore()
        }
    }
}

extension HealthKitManager {
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let types = Set([
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureSystolic)!,
            HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodPressureDiastolic)!,
        ])
        
        guard let healthStore = self.healthStore else { return completion(false) }
        
        healthStore.requestAuthorization(toShare: types, read: types) { (success, error) in
            if (error != nil) {
                self.error = .requestAuthorization
                completion(false)
            } else {
                self.refreshAuthorizationStatus()
                completion(success)
            }
        }
    }
    
    func refreshAuthorizationStatus() {
        guard let healthStore = self.healthStore else { return }
        
        let sysAuthorization = healthStore.authorizationStatus(for: HKQuantityType(.bloodPressureSystolic))
        let diaAuthorization = healthStore.authorizationStatus(for: HKQuantityType(.bloodPressureDiastolic))
        
        let notDetermined = sysAuthorization == .notDetermined && diaAuthorization == .notDetermined
        let denied = sysAuthorization == .sharingDenied || diaAuthorization == .sharingDenied
//        let authorized = sysAuthorization == .sharingAuthorized && diaAuthorization == .sharingAuthorized
        
        authorizationStatus = notDetermined ? .notDetermined : denied ? .sharingDenied : .sharingAuthorized
    }
}

extension HealthKitManager {
    func saveAnchor(_ anchor: HKQueryAnchor?) {
        if let encodedAnchor = try? NSKeyedArchiver.archivedData(withRootObject: anchor, requiringSecureCoding: true) {
            UserDefaults.standard.set(encodedAnchor, forKey: "lastHKAnchor")
        }
    }
    
    func loadAnchor() -> HKQueryAnchor? {
        guard let encodedAnchor = UserDefaults.standard.data(forKey: "lastHKAnchor"),
              let anchor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: HKQueryAnchor.self, from: encodedAnchor) else {
            return nil
        }
        return anchor
    }
}

extension HealthKitManager {
    func syncBloodPressure() async -> ([HKBloodPressureRecord], [UUID]) {
        guard let healthStore = self.healthStore else { return ([], []) }
        
        var anchor: HKQueryAnchor? = loadAnchor()
        var addedRecords = [HKBloodPressureRecord]()
        var deletedRecords = [UUID]()
        
        while true {
            let anchorDescriptor = HKAnchoredObjectQueryDescriptor(
                predicates: [.correlation(type: HKCorrelationType(.bloodPressure))],
                anchor: anchor,
                limit: 100
            )
            
            do {
                let queryResult = try await anchorDescriptor.result(for: healthStore)
                
                anchor = queryResult.newAnchor
                saveAnchor(anchor)
                
                for sample in queryResult.addedSamples {
                    guard let systolicSample = sample.objects(for: HKQuantityType.quantityType(forIdentifier: .bloodPressureSystolic)!).first as? HKQuantitySample,
                          let diastolicSample = sample.objects(for: HKQuantityType.quantityType(forIdentifier: .bloodPressureDiastolic)!).first as? HKQuantitySample else {
                        continue
                    }
                    
                    let systolicValue = systolicSample.quantity.doubleValue(for: .millimeterOfMercury())
                    let diastolicValue = diastolicSample.quantity.doubleValue(for: .millimeterOfMercury())
                    
                    addedRecords.append(HKBloodPressureRecord(uuid: sample.uuid, systolic: systolicValue, diastolic: diastolicValue, timestamp: sample.startDate))
                }
                
                deletedRecords.append(contentsOf: queryResult.deletedObjects.map { $0.uuid })
                
                print(queryResult.addedSamples.count)
                print(queryResult.deletedObjects.count)
                
                if (queryResult.addedSamples == []) && (queryResult.deletedObjects == []) {
                    break
                }
            } catch {
                self.error = .syncFromHK
                break
            }
        }
        
        return (addedRecords, deletedRecords)
    }
    
    func saveBloodPressureMeasurement(systolic: Double, diastolic: Double) async -> HKCorrelation? {
        guard let healthStore = self.healthStore else { return nil }
        
        do {
            let bloodPressureType = HKCorrelationType.correlationType(forIdentifier: .bloodPressure)!
            
            let systolicType = HKQuantityType.quantityType(forIdentifier: .bloodPressureSystolic)!
            let diastolicType = HKQuantityType.quantityType(forIdentifier: .bloodPressureDiastolic)!
            
            let systolicQuantity = HKQuantity(unit: .millimeterOfMercury(), doubleValue: systolic)
            let diastolicQuantity = HKQuantity(unit: .millimeterOfMercury(), doubleValue: diastolic)
            
            let now = Date()
            
            let systolicSample = HKQuantitySample(type: systolicType, quantity: systolicQuantity, start: now, end: now)
            let diastolicSample = HKQuantitySample(type: diastolicType, quantity: diastolicQuantity, start: now, end: now)
            
            let correlation = HKCorrelation(type: bloodPressureType, start: now, end: now, objects: [systolicSample, diastolicSample])
            
            try await healthStore.save(correlation)
            
            return correlation
        } catch {
            self.error = .saveToHK
        }
        
        return nil
    }
}
