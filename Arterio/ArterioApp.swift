//
//  ArterioApp.swift
//  Arterio
//
//  Created by Roland Kajatin on 11/08/2024.
//

import SwiftUI
import SwiftData

@main
struct ArterioApp: App {
    @State private var healthKitManager = HealthKitManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelDataContainer()
                .environment(healthKitManager)
        }
    }
}
