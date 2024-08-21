//
//  Overview.swift
//  Arterio
//
//  Created by Roland Kajatin on 16/08/2024.
//

import SwiftUI
import SwiftData

struct Overview: View {
    @Query(sort: \BPRecord.record.timestamp, order: .reverse) var records: [BPRecord]
    
    @State private var showEditor = false
    
    var body: some View {
        if records.isEmpty {
            NoRecordsView()
        } else {
            ZStack(alignment: .bottomTrailing) {
                Color.antiFlashWhite
                
                VStack {
                    RecentBanner(record: records.first!)
                        .frame(height: 200)
                        .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 24, bottomTrailingRadius: 24))
                        .shadow(color: .black.opacity(0.2), radius: 0, x: 0, y: 4)
                    
                    HistoryOfRecords()
                }
                
                Button {
                    showEditor.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                .buttonStyle(ProminentFAB())
            }
            .ignoresSafeArea()
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
            .padding(.horizontal, 20)
            .padding(.vertical, 32)
    }
}

#Preview {
    Overview()
        .modelDataContainer(inMemory: true)
}
