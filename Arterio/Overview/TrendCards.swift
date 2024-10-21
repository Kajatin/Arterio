//
//  TrendCards.swift
//  Arterio
//
//  Created by Roland Kajatin on 19/10/2024.
//

import SwiftUI

struct TrendCards: View {
    var records: [BPRecord]
    var selectedTimeRange: TimeRange
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Trends")
                .font(.system(size: 24, weight: .bold, design: .serif))
                .foregroundStyle(.antiFlashWhite)
                .padding(.horizontal)
            
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    RangeTrend(selectedTimeRange: selectedTimeRange, filteredRecords: filteredRecords)
                    StressTrend()
                    MinMaxTrend(filteredRecords: filteredRecords)
                }
                .padding(.bottom, 4)
            }
            .scrollIndicators(.never)
            .contentMargins(.horizontal, 20, for: .scrollContent)
        }
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
        
        return records.filter { $0.record!.timestamp >= startDate }
    }
    
    struct RangeTrend: View {
        var selectedTimeRange: TimeRange
        var filteredRecords: [BPRecord]
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text("\(selectedTimeRange.rawValue)ly average")
                    .font(.system(size: 16, weight: .bold, design: .serif))
                    .opacity(0.6)
                
                HStack(alignment: .firstTextBaseline) {
                    let averageSystolic = filteredRecords.reduce(0) { $0 + $1.record!.systolic } / Double(filteredRecords.count)
                    let averageDiastolic = filteredRecords.reduce(0) { $0 + $1.record!.diastolic } / Double(filteredRecords.count)
                    Text("\(averageSystolic.rounded().formatted())/\(averageDiastolic.rounded().formatted())")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                    
                    Text("mmHg")
                        .font(.system(size: 14, weight: .bold, design: .serif))
                        .opacity(0.6)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(.antiFlashWhite)
                    .shadow(color: .black.opacity(0.2), radius: 0, x: 0, y: 4)
            )
        }
    }
    
    struct StressTrend: View {
        var stress: Stress = .low
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text("Stress level")
                    .font(.system(size: 16, weight: .bold, design: .serif))
                    .opacity(0.6)
                
                HStack(alignment: .firstTextBaseline) {
                    Text("\(stress.rawValue.lowercased())")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                    
                    let icon = switch stress {
                    case .low:
                        "1.square"
                    case .medium:
                        "2.square"
                    case .high:
                        "3.square"
                    }
                    
                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .opacity(0.6)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(.antiFlashWhite)
                    .shadow(color: .black.opacity(0.2), radius: 0, x: 0, y: 4)
            )
        }
    }
    
    struct MinMaxTrend: View {
        var filteredRecords: [BPRecord]
        
        @State private var showingSystolic = true
        @State private var timer: Timer? = nil
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text("\(showingSystolic ? "Systolic" : "Diastolic") range")
                    .font(.system(size: 16, weight: .bold, design: .serif))
                    .opacity(0.6)
                
                HStack {
                    if showingSystolic {
                        let minSys = filteredRecords.min(by: { $0.record!.systolic < $1.record!.systolic })?.record!.systolic ?? 0
                        let maxSys = filteredRecords.max(by: { $0.record!.systolic < $1.record!.systolic })?.record!.systolic ?? 0
                        Text("\(minSys.rounded().formatted())")
                            .font(.system(size: 28, weight: .bold, design: .serif))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 20, weight: .bold, design: .serif))
                        Text("\(maxSys.rounded().formatted())")
                            .font(.system(size: 28, weight: .bold, design: .serif))
                    } else {
                        let minDia = filteredRecords.min(by: { $0.record!.diastolic < $1.record!.diastolic })?.record!.diastolic ?? 0
                        let maxDia = filteredRecords.max(by: { $0.record!.diastolic < $1.record!.diastolic })?.record!.diastolic ?? 0
                        Text("\(minDia.rounded().formatted())")
                            .font(.system(size: 28, weight: .bold, design: .serif))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 20, weight: .bold, design: .serif))
                        Text("\(maxDia.rounded().formatted())")
                            .font(.system(size: 28, weight: .bold, design: .serif))
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(.antiFlashWhite)
                    .shadow(color: .black.opacity(0.2), radius: 0, x: 0, y: 4)
            )
            .onAppear {
                startTimer()
            }
            .onDisappear {
                stopTimer()
            }
        }
        
        private func startTimer() {
            timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
                withAnimation {
                    showingSystolic.toggle()
                }
            }
        }
        
        private func stopTimer() {
            timer?.invalidate()
            timer = nil
        }
    }
}
