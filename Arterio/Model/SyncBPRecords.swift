//
//  SyncBPRecords.swift
//  Arterio
//
//  Created by Roland Kajatin on 16/08/2024.
//

import SwiftUI
import SwiftData

struct SyncBPRecordsViewModifier: ViewModifier {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.modelContext) private var context
    @Environment(HealthKitManager.self) private var healthKitManager
    
    init() {}
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                syncRecords()
            }
            .onChange(of: scenePhase) { old, new in
                if new == .active {
                    syncRecords()
                }
            }
    }
    
    private func syncRecords() {
        healthKitManager.requestAuthorization { result in
            Task {
                let (addedRecords, deletedRecords) = await healthKitManager.syncBloodPressure()
                
                // Register new records that were added in Apple Health.
                let swiftDataRecords = try context.fetch(FetchDescriptor<BPRecord>())
                for record in addedRecords {
                    if !swiftDataRecords.contains(where: { $0.HKUuid == record.uuid }) {
                        context.insert(BPRecord(record: record))
                    }
                }
                
                // Remove records that were deleted from Apple Health.
                let recordsToDelete = try context.fetch(FetchDescriptor<BPRecord>(
                    predicate: #Predicate { record in
                        deletedRecords.contains(record.HKUuid)
                    }
                ))
                for record in recordsToDelete {
                    context.delete(record)
                }
                
                try context.save()
            }
        }
    }
}

public extension View {
    internal func syncBPRecords() -> some View {
        modifier(SyncBPRecordsViewModifier())
    }
}
