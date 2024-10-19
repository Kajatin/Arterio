//
//  Overview.swift
//  Arterio
//
//  Created by Roland Kajatin on 16/08/2024.
//

import SwiftUI
import SwiftData

enum TimeRange: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
}

struct Overview: View {
    @Binding var navigationPath: [BPRecord]
    
    @Query(sort: \BPRecord.record.timestamp, order: .reverse) var records: [BPRecord]
    
    @State private var showEditor = false
    @State private var selectedTimeRange: TimeRange = .week
    
    var body: some View {
        if records.isEmpty {
            NoRecordsView()
        } else {
            ZStack(alignment: .bottomTrailing) {
                Color.hookersGreen
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        RecentBanner(record: records.first!, records: records)
                        TrendCards(records: records, selectedTimeRange: selectedTimeRange)
                        Insights(records: records, selectedTimeRange: $selectedTimeRange)
                        // HistoryOfRecords(records: records)
                    }
                }
                
                Button {
                    showEditor.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                .buttonStyle(ProminentFAB())
                .padding(.horizontal)
            }
            .sheet(isPresented: $showEditor) {
                BPEditor()
            }
        }
    }
}

struct ProminentFAB: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 55, minHeight: 55, alignment: .center)
            .font(.system(size: 22, weight: .bold, design: .serif))
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.tomato)
                    .shadow(color: .black.opacity(0.2), radius: 0, x: 0, y: 4)
            )
            .foregroundStyle(.antiFlashWhite)
    }
}

#Preview {
    @Previewable @State var path: [BPRecord] = []
    NavigationStack {
        Overview(navigationPath: $path)
            .modelDataContainer(inMemory: true)
    }
}
