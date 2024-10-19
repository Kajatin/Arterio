//
//  CustomBottomTabBarView.swift
//  Arterio
//
//  Created by Roland Kajatin on 31/08/2024.
//

import SwiftUI

private let buttonDimen: CGFloat = 55

struct CustomBottomTabBarView: View {
    @Binding var selection: AppScreen?
    
    var body: some View {
        HStack {
            TabBarButton(imageName: "house")
                .frame(width: buttonDimen, height: buttonDimen)
                .onTapGesture {
                    selection = .home
                }
            
            Spacer()
            
            TabBarButton(imageName: "house")
                .frame(width: buttonDimen, height: buttonDimen)
                .onTapGesture {
                    selection = .trends
                }
            
            Spacer()
            
            TabBarButton(imageName: "house")
                .frame(width: buttonDimen, height: buttonDimen)
                .onTapGesture {
                    selection = .learn
                }
            
        }
        .frame(width: (buttonDimen * CGFloat(AppScreen.allCases.count)) + 60)
        .tint(Color.black)
        .padding(.vertical, 2.5)
        .background(Color.white)
        .clipShape(Capsule(style: .continuous))
        .overlay {
            SelectedTabCircleView(selection: $selection)
        }
        .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 10)
        .animation(.interactiveSpring(response: 0.5, dampingFraction: 0.65, blendDuration: 0.65), value: selection)
    }
}

private struct TabBarButton: View {
    let imageName: String
    var body: some View {
        Image(systemName: imageName)
            .renderingMode(.template)
            .tint(.black)
            .fontWeight(.bold)
    }
}

struct SelectedTabCircleView: View {
    @Binding var selection: AppScreen?
    
    private var horizontalOffset: CGFloat {
        switch selection {
        case .home:
            return -72
        case .trends:
            return 0
        case .learn:
            return 72
        case .none:
            return 0
        }
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue)
                .frame(width: buttonDimen , height: buttonDimen)
            
            TabBarButton(imageName: "house")
                .foregroundColor(.white)
        }
        .offset(x: horizontalOffset)
    }
    
}

#Preview {
    @Previewable @State var selection: AppScreen? = .home
    CustomBottomTabBarView(selection: $selection)
}
