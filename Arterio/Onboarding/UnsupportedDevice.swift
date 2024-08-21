//
//  UnsupportedDevice.swift
//  Arterio
//
//  Created by Roland Kajatin on 18/08/2024.
//

import SwiftUI

struct UnsupportedDevice: View {
    var body: some View {
        ZStack(alignment: .center) {
            Color.tomato
                .ignoresSafeArea()
            
            
            GeometryReader { geo in
                VStack(alignment: .center) {
                    Text("Unsupported device")
                        .font(.system(size: 44, weight: .bold, design: .serif))
                        .foregroundStyle(.antiFlashWhite)
                        .multilineTextAlignment(.center)
                        .frame(width: geo.size.width)
                        .offset(y: geo.size.height * 0.05)
                    
                    Text("Apologies, but your device is not supported.")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 22, weight: .bold, design: .serif))
                        .foregroundStyle(.antiFlashWhite)
                        .offset(y: geo.size.height * 0.24)
                }
            }
            .padding()
        }
    }
}

#Preview {
    UnsupportedDevice()
}
