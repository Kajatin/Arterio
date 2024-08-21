//
//  Welcome.swift
//  Arterio
//
//  Created by Roland Kajatin on 17/08/2024.
//

import SwiftUI

struct Welcome: View {
    @Environment(HealthKitManager.self) private var healthKitManager
    @Environment(\.scenePhase) var scenePhase
    
    @Namespace private var welcomeAnimation
    
    var body: some View {
        if healthKitManager.healthStore != nil {
            Group {
                if healthKitManager.error != nil {
                    WelcomeError()
                } else if healthKitManager.authorizationStatus == .sharingDenied {
                    SharingDenied(namespace: welcomeAnimation)
                } else if healthKitManager.authorizationStatus == .sharingAuthorized {
                    SharingAuthorized(namespace: welcomeAnimation)
                } else {
                    RequestSharing(namespace: welcomeAnimation)
                }
            }
            .onChange(of: scenePhase) { old, new in
                if new == .active {
                    healthKitManager.refreshAuthorizationStatus()
                }
            }
        } else {
            UnsupportedDevice()
        }
    }
}

#Preview {
    @Previewable @State var healthKitManager = HealthKitManager()
    
    return Welcome()
        .environment(healthKitManager)
}
