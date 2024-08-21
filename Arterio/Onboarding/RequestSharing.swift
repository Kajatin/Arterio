//
//  RequestSharing.swift
//  Arterio
//
//  Created by Roland Kajatin on 18/08/2024.
//

import SwiftUI

struct RequestSharing: View {
    @Environment(HealthKitManager.self) private var healthKitManager
    
    let namespace: Namespace.ID
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.hookersGreen
                .ignoresSafeArea()
            
            CurvedTopShape()
                .fill(.tomato)
                .ignoresSafeArea()
                .frame(width: .infinity, height: 240)
                .shadow(color: .black.opacity(0.2), radius: 0, x: 12, y: -4)
                .matchedGeometryEffect(id: "curvedTopShape", in: namespace)
            
            GeometryReader { geo in
                VStack(alignment: .center) {
                    Text("Welcome")
                        .font(.system(size: 44, weight: .bold, design: .serif))
                        .foregroundStyle(.antiFlashWhite)
                        .offset(y: geo.size.height * 0.05)
                    
                    Text("Track your blood pressure and see your health trends at a glance.")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 22, weight: .bold, design: .serif))
                        .foregroundStyle(.antiFlashWhite)
                        .offset(y: geo.size.height * 0.18)
                    
                    Text("Begin your journey by connecting with Apple Health and syncing your measurements.")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 22, weight: .bold, design: .serif))
                        .foregroundStyle(.antiFlashWhite)
                        .offset(y: geo.size.height * 0.22)
                    
                    Spacer()
                    
                    Button {
                        healthKitManager.requestAuthorization { _ in }
                    } label: {
                        Text("Connect")
                    }
                    .buttonStyle(ProminentTomatoButton())
                    .padding(.bottom, 32)
                }
            }
            .padding()
        }
    }
}

struct ProminentTomatoButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, minHeight: 55, alignment: .center)
            .font(.system(size: 22, weight: .bold, design: .serif))
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.antiFlashWhite)
                    .shadow(color: .black.opacity(0.2), radius: 0, x: 0, y: 4)
            )
            .foregroundStyle(.tomato)
            .padding(.horizontal, 24)
    }
}

struct CurvedTopShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.24739*width, y: 0.01171*height))
        path.addCurve(to: CGPoint(x: 0.01902*width, y: 0.11937*height), control1: CGPoint(x: 0.14375*width, y: 0.01533*height), control2: CGPoint(x: 0.01902*width, y: 0.11937*height))
        path.addLine(to: CGPoint(x: -0.06124*width, y: 0.1732*height))
        path.addLine(to: CGPoint(x: -0.06124*width, y: height))
        path.addLine(to: CGPoint(x: 1.06124*width, y: height))
        path.addLine(to: CGPoint(x: 1.06124*width, y: 0.15136*height))
        path.addCurve(to: CGPoint(x: 0.87009*width, y: 0.07292*height), control1: CGPoint(x: 1.06124*width, y: 0.15136*height), control2: CGPoint(x: 0.95322*width, y: 0.08269*height))
        path.addCurve(to: CGPoint(x: 0.53703*width, y: 0.1978*height), control1: CGPoint(x: 0.72778*width, y: 0.0562*height), control2: CGPoint(x: 0.67993*width, y: 0.21101*height))
        path.addCurve(to: CGPoint(x: 0.24739*width, y: 0.01171*height), control1: CGPoint(x: 0.39245*width, y: 0.18445*height), control2: CGPoint(x: 0.39281*width, y: 0.00663*height))
        path.closeSubpath()
        return path
    }
}

#Preview {
    @Previewable @State var healthKitManager = HealthKitManager()
    @Previewable @Namespace var welcomeAnimation
    
    return RequestSharing(namespace: welcomeAnimation)
        .environment(healthKitManager)
}
