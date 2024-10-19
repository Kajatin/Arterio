//
//  ContentView.swift
//  Arterio
//
//  Created by Roland Kajatin on 11/08/2024.
//

import SwiftUI
import SwiftData

// systolic/diastolic
// heart rate?
// date
// position (sitting, lying, standing)
// arm (left right)
// time of day (morning, afternoon, evening, night)
// before or after specific activities (exercise, meal)
// general mood
// stress level (reported by user)
// tags + notes

struct ContentView: View {
    @State private var selection: AppScreen? = .home
    
    @AppStorage("needsOnboarding") var needsOnboarding = true
    
    var body: some View {
        if needsOnboarding {
            Welcome()
        } else {
//            AppTabView(selection: $selection)
//                .syncBPRecords()
            HomeNavigationStack()
                .syncBPRecords()
        }
    }
}

#Preview {
    ContentView()
}
