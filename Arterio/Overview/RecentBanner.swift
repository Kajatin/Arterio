//
//  RecentBanner.swift
//  Arterio
//
//  Created by Roland Kajatin on 16/08/2024.
//

import SwiftUI

struct RecentBanner: View {
    var record: BPRecord
    var records: [BPRecord]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(record.record.timestamp, format: Date.RelativeFormatStyle(presentation: .named, capitalizationContext: .beginningOfSentence))
                .font(.system(size: 24, weight: .bold, design: .serif))
            
            HStack(alignment: .center) {
                HStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("sys".uppercased())
                            .font(.system(size: 18, weight: .bold, design: .serif))
                            .opacity(0.6)
                        
                        Text(record.record.systolic.formatted())
                            .font(.system(size: 48, weight: .black, design: .serif))
                    }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("dia".uppercased())
                            .font(.system(size: 18, weight: .bold, design: .serif))
                            .opacity(0.6)
                        
                        Text(record.record.diastolic.formatted())
                            .font(.system(size: 48, weight: .black, design: .serif))
                    }
                }
                
                Spacer()
                
                HStack {
                    if let timeOfDay = record.timeOfDay {
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
                    
                    if let position = record.position {
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
                    
                    if let arm = record.arm {
                        ZStack {
                            Image(systemName: "hand.raised")
                                .font(.system(size: 24))
                                .rotation3DEffect(.degrees(arm == .left ? 180 : 0), axis: (0, 1, 0))
                            Text(arm == .left ? "L" : "R")
                                .font(.system(size: 10, weight: .bold, design: .serif))
                                .offset(y: 4)
                        }
                    }
                    
                    if let stress = record.stress {
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
        }
        .foregroundStyle(.antiFlashWhite)
        .padding(.horizontal)
    }
}

//#Preview {
//    RecentBanner(record: .init(record: HKBloodPressureRecord(uuid: UUID(), systolic: 120, diastolic: 80, timestamp: .now)))
//}
