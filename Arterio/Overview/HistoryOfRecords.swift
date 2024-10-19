//
//  HistoryOfRecords.swift
//  Arterio
//
//  Created by Roland Kajatin on 21/08/2024.
//

import SwiftUI
import SwiftData

struct HistoryOfRecords: View {
//    @Query(sort: \BPRecord.record.timestamp, order: .reverse) var records: [BPRecord]
    var records: [BPRecord]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 8) {
                ForEach(records, id: \.HKUuid) { rec in
                    HStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("sys".uppercased())
                                .font(.system(size: 12, weight: .bold, design: .serif))
                                .opacity(0.6)
                            
                            Text(rec.record.systolic.formatted())
                                .font(.system(size: 32, weight: .black, design: .serif))
                        }
                        
                        VStack(alignment: .leading, spacing: 0) {
                            Text("dia".uppercased())
                                .font(.system(size: 12, weight: .bold, design: .serif))
                                .opacity(0.6)
                            
                            Text(rec.record.diastolic.formatted())
                                .font(.system(size: 32, weight: .black, design: .serif))
                        }
                        
                        Spacer()
                        
                        HStack {
                            if let timeOfDay = rec.timeOfDay {
                                let icon = switch timeOfDay {
                                case .morning:
                                    "sun.horizon.fill"
                                case .afternoon:
                                    "sun.max.fill"
                                case .evening:
                                    "moon.fill"
                                case .night:
                                    "moon.stars.fill"
                                }
                                
                                Image(systemName: icon)
                                    .font(.system(size: 24))
                            }
                            
                            if let position = rec.position {
                                let icon = switch position {
                                case .lying:
                                    "bed.double"
                                case .sitting:
                                    "chair"
                                case .standing:
                                    "figure.stand"
                                }
                                
                                Image(systemName: icon)
                                    .font(.system(size: 24))
                            }
                            
                            if let arm = rec.arm {
                                ZStack {
                                    Image(systemName: "hand.raised")
                                        .font(.system(size: 24))
                                        .rotation3DEffect(.degrees(arm == .left ? 180 : 0), axis: (0, 1, 0))
                                    Text(arm == .left ? "L" : "R")
                                        .font(.system(size: 10, weight: .bold, design: .serif))
                                        .offset(y: 4)
                                }
                            }
                            
                            if let stress = rec.stress {
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
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.hookersGreen, lineWidth: 2)
                    )
                }
            }
        }
        .padding(.horizontal)
        .scrollIndicators(.hidden)
    }
}

//#Preview {
//    HistoryOfRecords()
//        .modelDataContainer(inMemory: true)
//}
