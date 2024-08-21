//
//  SharingDenied.swift
//  Arterio
//
//  Created by Roland Kajatin on 18/08/2024.
//

import SwiftUI

struct SharingDenied: View {
    let namespace: Namespace.ID
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.tomato
                .ignoresSafeArea()
                .matchedGeometryEffect(id: "curvedTopShape", in: namespace)
                
            
            GeometryReader { geo in
                VStack(alignment: .center) {
                    Text("Denied")
                        .font(.system(size: 44, weight: .bold, design: .serif))
                        .foregroundStyle(.antiFlashWhite)
                        .offset(y: geo.size.height * 0.05)
                    
                    Text("You have denied access to Apple Health. This app requires access to function properly.")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 22, weight: .bold, design: .serif))
                        .foregroundStyle(.antiFlashWhite)
                        .offset(y: geo.size.height * 0.24)
                    
                    Text("To adjust the permissions, go to Settings > Health > Data Access > Arterio.")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 22, weight: .bold, design: .serif))
                        .foregroundStyle(.antiFlashWhite)
                        .offset(y: geo.size.height * 0.34)
                    
                    Spacer()
                    
                    Button {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Text("Open settings")
                    }
                    .buttonStyle(ProminentTomatoButton())
                    .padding(.bottom, 32)
                }
            }
            .padding()
        }
    }
}

#Preview {
    @Previewable @Namespace var welcomeAnimation
    SharingDenied(namespace: welcomeAnimation)
}
