//
//  SharingAuthorized.swift
//  Arterio
//
//  Created by Roland Kajatin on 18/08/2024.
//

import SwiftUI

import SwiftUI

struct SharingAuthorized: View {
    @AppStorage("needsOnboarding") var needsOnboarding = true
    
    let namespace: Namespace.ID
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.hookersGreen
                .ignoresSafeArea()
            
            CurvedTopShape()
                .fill(.tomato)
                .ignoresSafeArea()
                .frame(width: .infinity, height: 540)
                .shadow(color: .black.opacity(0.2), radius: 0, x: 12, y: -4)
                .matchedGeometryEffect(id: "curvedTopShape", in: namespace)
            
            GeometryReader { geo in
                VStack(alignment: .center) {
                    Text("Welcome")
                        .font(.system(size: 44, weight: .bold, design: .serif))
                        .foregroundStyle(.antiFlashWhite)
                        .offset(y: geo.size.height * 0.05)
                    
                    Text("You are all set!")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 22, weight: .bold, design: .serif))
                        .foregroundStyle(.antiFlashWhite)
                        .offset(y: geo.size.height * 0.44)
                    
                    Text("Dive in to start tracking your blood pressure.")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 22, weight: .bold, design: .serif))
                        .foregroundStyle(.antiFlashWhite)
                        .offset(y: geo.size.height * 0.54)
                    
                    Spacer()
                    
                    Button {
                        withAnimation {
                            needsOnboarding = false
                        }
                    } label: {
                        Text("Get started")
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
    SharingAuthorized(namespace: welcomeAnimation)
}
