//
//  ResizableHeaderView.swift
//  Arterio
//
//  Created by Roland Kajatin on 11/08/2024.
//

import SwiftUI

struct ResizableHeaderView: View {
    var size: CGSize
    var safeArea: EdgeInsets
    @State private var offsetY: CGFloat = 0
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    HeaderView()
                        .zIndex(100)
                    
                    sampleCardsView()
                }
                .id("ResizableHeaderDetailView")
                .background {
                    ScrollDetector { offset in
                        offsetY = -offset
                    } onDraggingEnd: { offset, velocity in
                        let headerHeight = 250 + safeArea.top
                        let minimumHeaderHeight = 65 + safeArea.top
                        let targetEnd = offset + velocity * 45
                        if targetEnd < (headerHeight - minimumHeaderHeight) && targetEnd > 0 {
                            withAnimation(.interactiveSpring(response: 0.55, dampingFraction: 0.65, blendDuration: 0.65)) {
                                scrollProxy.scrollTo("ResizableHeaderDetailView", anchor: .top)
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        let headerHeight = 300 + safeArea.top
        let minimumHeaderHeight = 100 + safeArea.top
        // 0-1之间
        let progress = max(min(-offsetY / (headerHeight - minimumHeaderHeight), 1), 0)
        GeometryReader { _ in
            ZStack {
                Rectangle()
                    .fill(.pink.gradient)
                
                HeaderSubView(headerHeight: headerHeight, minimumHeaderHeight: minimumHeaderHeight, progress: progress)
            }
            .frame(height: ((headerHeight + offsetY) < minimumHeaderHeight ? minimumHeaderHeight : (headerHeight + offsetY)), alignment: .bottom)
            .offset(y: -offsetY)
        }
        .frame(height: headerHeight)
    }
    
    @ViewBuilder
    func sampleCardsView() -> some View {
        VStack(spacing: 15) {
            ForEach(1...20, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(.black.opacity(0.05))
                    .frame(height: 75)
            }
        }
        .padding(15)
    }
    
    @ViewBuilder
    func HeaderSubView(headerHeight: CGFloat, minimumHeaderHeight: CGFloat, progress: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Systolic/diastolic values
            HStack(spacing: 60) {
                VStack(alignment: .leading) {
                    Text("sys".uppercased())
                        .font(.system(size: 20, weight: .bold, design: .serif))
                        .foregroundStyle(.secondary)
                        .opacity(1 - progress)
                    Text("126")
                        .font(.system(size: 60, weight: .black, design: .serif))
                }
                
                VStack(alignment: .leading) {
                    Text("dia".uppercased())
                        .font(.system(size: 20, weight: .bold, design: .serif))
                        .foregroundStyle(.secondary)
                        .opacity(1 - progress)
                    Text("82")
                        .font(.system(size: 60, weight: .black, design: .serif))
                }
            }
            .position(x: -progress * 50 + size.width / 2, y: -progress * 70 + 100)
            
            HStack {
                // Time of day badge
                Image(systemName: "moon.fill")
                    .padding(5)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 4))
                
                // Mood (1-10)
                Image(systemName: "09.square.fill")
                    .padding(5)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 4))
                
                // Stress (1-10)
                Image(systemName: "02.square.fill")
                    .padding(5)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 4))
            }
            .opacity(1 - progress)
        }
        .padding(.top, safeArea.top)
        .padding(.bottom, 15)
    }
}

#Preview {
    GeometryReader { proxy in
        ResizableHeaderView(size: proxy.size, safeArea: proxy.safeAreaInsets)
            .ignoresSafeArea(.all, edges: .top)
    }
}
