//
//  Insights.swift
//  Arterio
//
//  Created by Roland Kajatin on 22/08/2024.
//

import SwiftUI
import Charts

struct Insights: View {
    var records: [BPRecord]
    @Binding var selectedTimeRange: TimeRange
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Insights")
                .font(.system(size: 24, weight: .bold, design: .serif))
                .foregroundStyle(.antiFlashWhite)
            
            Chart {
                ForEach(filteredRecords, id: \.HKUuid) { record in
                    LineMark(
                        x: .value("Date", record.record.timestamp),
                        y: .value("Systolic", record.record.systolic),
                        series: .value("Type", "Systolic")
                    )
                    .foregroundStyle(.hookersGreen)
                    .lineStyle(.init(lineWidth: 6))
                    .interpolationMethod(.catmullRom)
                    
                    LineMark(
                        x: .value("Date", record.record.timestamp),
                        y: .value("Diastolic", record.record.diastolic),
                        series: .value("Type", "Diastolic")
                    )
                    .foregroundStyle(.black)
                    .lineStyle(.init(lineWidth: 6))
                    .interpolationMethod(.catmullRom)
                }
            }
            .chartYScale(domain: [(records.min(by: { $0.record.diastolic < $1.record.diastolic })?.record.diastolic ?? 10) - 10, (records.max(by: { $0.record.systolic < $1.record.systolic })?.record.systolic ?? 160) + 10])
            .frame(height: 200)
            .padding()
            .background(.antiFlashWhite, in: RoundedRectangle(cornerRadius: 18))
            
            TimeRangePicker(preselectedIndex: $selectedTimeRange)
        }
        .padding(.horizontal)
    }
    
    var filteredRecords: [BPRecord] {
        let calendar = Calendar.current
        let startDate: Date
        
        switch selectedTimeRange {
        case .week:
            startDate = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        case .year:
            startDate = calendar.date(byAdding: .year, value: -1, to: Date()) ?? Date()
        }
        
        return records.filter { $0.record.timestamp >= startDate }
    }
    
    var strideBy: Calendar.Component {
        switch selectedTimeRange {
        case .week:
            return .day
        case .month:
            return .weekOfMonth
        case .year:
            return .month
        }
    }
}

struct TimeRangePicker: View {
    @Binding var preselectedIndex: TimeRange
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TimeRange.allCases, id:\.self) { index in
                ZStack {
                    Rectangle()
                        .fill(.antiFlashWhite)
                    
                    Rectangle()
                        .fill(.hookersGreen)
                        .cornerRadius(12)
                        .padding(3)
                        .opacity(preselectedIndex == index ? 1 : 0.01)
                        .onTapGesture {
                            withAnimation(.interactiveSpring(duration: 0.35)) {
                                preselectedIndex = index
                            }
                        }
                }
                .overlay(
                    Text(index.rawValue)
                        .font(.system(size: 16, weight: .medium, design: .serif))
                        .foregroundStyle(preselectedIndex == index ? .antiFlashWhite : .primary)
                )
            }
        }
        .frame(height: 40)
        .cornerRadius(14)
    }
}
