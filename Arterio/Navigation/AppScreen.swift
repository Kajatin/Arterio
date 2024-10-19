//
//  AppScreen.swift
//  Arterio
//
//  Created by Roland Kajatin on 31/08/2024.
//

import SwiftUI

enum AppScreen: Codable, Hashable, Identifiable, CaseIterable {
    case home
    case trends
    case learn
    
    var id: AppScreen { self }
}

extension AppScreen {
    @ViewBuilder
    var label: some View {
        switch self {
        case .home:
            Label("Home", systemImage: "house")
        case .trends:
            Label("Trends", systemImage: "house")
        case .learn:
            Label("Learn", systemImage: "house")
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .home:
            HomeNavigationStack()
        case .trends:
            TrendsNavigationStack()
        case .learn:
            LearnNavigationStack()
        }
    }
}

