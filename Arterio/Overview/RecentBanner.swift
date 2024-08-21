//
//  RecentBanner.swift
//  Arterio
//
//  Created by Roland Kajatin on 16/08/2024.
//

import SwiftUI

struct RecentBanner: View {
    var record: BPRecord
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.hookersGreen
            
            HStack(alignment: .center) {
                HStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("sys".uppercased())
                            .font(.system(size: 18, weight: .bold, design: .serif))
                            .foregroundStyle(.antiFlashWhite)
                            .opacity(0.6)
                        
                        Text(record.record.systolic.formatted())
                            .font(.system(size: 48, weight: .black, design: .serif))
                            .foregroundStyle(.antiFlashWhite)
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("dia".uppercased())
                            .font(.system(size: 18, weight: .bold, design: .serif))
                            .foregroundStyle(.antiFlashWhite)
                            .opacity(0.6)
                        
                        Text(record.record.diastolic.formatted())
                            .font(.system(size: 48, weight: .black, design: .serif))
                            .foregroundStyle(.antiFlashWhite)
                    }
                }
                
                Spacer()
                
                ZStack {
                    Trends(points: [0.3, 0.6, 0.4, 0.7, 0.5, 0.2, 0.8, 0.1])
                        .stroke(.antiFlashWhite, lineWidth: 3)
                        .frame(width: 160, height: 100)
                    
                    Trends(points: [0.34, 0.75, 0.5, 0.78, 0.52, 0.38, 0.91, 0.26])
                        .stroke(.antiFlashWhite.opacity(0.6), lineWidth: 3)
                        .frame(width: 160, height: 100)
                }
            }
            .padding()
        }
    }
}

struct Trends: Shape {
    var points: [Double]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY * CGFloat(points[0])))
        
        points.enumerated().forEach { p in
            path.addLine(to: CGPoint(x: rect.maxX * CGFloat(p.offset) / CGFloat(points.count), y: rect.maxY * p.element))
        }
        
        return path
    }
}

#Preview {
    RecentBanner(record: .init(record: HKBloodPressureRecord(uuid: UUID(), systolic: 120, diastolic: 80, timestamp: .now)))
}
