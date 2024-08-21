//
//  WelcomeError.swift
//  Arterio
//
//  Created by Roland Kajatin on 18/08/2024.
//

import SwiftUI

struct WelcomeError: View {
    var body: some View {
        ZStack(alignment: .center) {
            Color.tomato
                .ignoresSafeArea()
            
            
            GeometryReader { geo in
                VStack(alignment: .center) {
                    Text("Error")
                        .font(.system(size: 44, weight: .bold, design: .serif))
                        .foregroundStyle(.antiFlashWhite)
                        .frame(width: geo.size.width)
                        .offset(y: geo.size.height * 0.05)
                    
                    Text("Something went wrong.")
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
    WelcomeError()
}
