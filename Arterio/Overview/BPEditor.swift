//
//  BPEditor.swift
//  Arterio
//
//  Created by Roland Kajatin on 19/08/2024.
//

import SwiftUI

struct BPEditor: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Environment(HealthKitManager.self) private var healthKitManager
    
    @State var systolic: Double = 120
    @State var diastolic: Double = 80
    @State var arm = Arm.left
    @State var position = Position.sitting
    @State var stress = Stress.low
    @State var notes = ""
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.tomato
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Text("Measurement")
                    .font(.system(size: 44, weight: .bold, design: .serif))
                    .foregroundStyle(.antiFlashWhite)
                    .padding(.top)
                
                ScrollView {
                    VStack(spacing: 16) {
                        HStack(spacing: 32) {
                            VStack {
                                Text("Systolic")
                                    .font(.system(size: 22, weight: .bold, design: .serif))
                                    .foregroundStyle(.antiFlashWhite)
                                
                                Picker("Systolic", selection: $systolic) {
                                    ForEach(0...300, id: \.self) { value in
                                        Text("\(value)")
                                            .foregroundStyle(.tomato)
                                            .font(.system(size: 22, weight: .bold, design: .serif))
                                            .tag(Double(value))
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(width: 130, height: 150)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.antiFlashWhite)
                                        .shadow(color: .black.opacity(0.2), radius: 0, x: 0, y: 4)
                                )
                            }
                            
                            VStack {
                                Text("Diastolic")
                                    .font(.system(size: 22, weight: .bold, design: .serif))
                                    .foregroundStyle(.antiFlashWhite)
                                
                                Picker("Diastolic", selection: $diastolic) {
                                    ForEach(0...300, id: \.self) { value in
                                        Text("\(value)")
                                            .foregroundStyle(.tomato)
                                            .font(.system(size: 22, weight: .bold, design: .serif))
                                            .tag(Double(value))
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(width: 130, height: 150)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.antiFlashWhite)
                                        .shadow(color: .black.opacity(0.2), radius: 0, x: 0, y: 4)
                                )
                            }
                        }
                        
                        VStack {
                            Text("Arm")
                                .font(.system(size: 22, weight: .bold, design: .serif))
                                .foregroundStyle(.antiFlashWhite)
                            
                            HStack {
                                ForEach(Arm.allCases, id: \.self) { a in
                                    Button {
                                        withAnimation {
                                            arm = a
                                        }
                                    } label: {
                                        Text(a.rawValue)
                                    }
                                    .buttonStyle(TomatoButton(selected: arm == a))
                                }
                            }
                        }
                        
                        VStack {
                            Text("Position")
                                .font(.system(size: 22, weight: .bold, design: .serif))
                                .foregroundStyle(.antiFlashWhite)
                            
                            HStack {
                                ForEach(Position.allCases, id: \.self) { p in
                                    Button {
                                        withAnimation {
                                            position = p
                                        }
                                    } label: {
                                        Text(p.rawValue)
                                    }
                                    .buttonStyle(TomatoButton(selected: position == p))
                                }
                            }
                        }
                        
                        VStack {
                            Text("Stress level")
                                .font(.system(size: 22, weight: .bold, design: .serif))
                                .foregroundStyle(.antiFlashWhite)
                            
                            HStack {
                                ForEach(Stress.allCases, id: \.self) { s in
                                    Button {
                                        withAnimation {
                                            stress = s
                                        }
                                    } label: {
                                        Text(s.rawValue)
                                    }
                                    .buttonStyle(TomatoButton(selected: stress == s))
                                }
                            }
                        }
                        
                        Button("Save") {
                            Task {
                                let newMeasurement = await healthKitManager.saveBloodPressureMeasurement(systolic: systolic, diastolic: diastolic)
                                
                                if let uuid = newMeasurement?.uuid, let timestamp = newMeasurement?.startDate {
                                    let newRecord = BPRecord(record: HKBloodPressureRecord(uuid: uuid, systolic: systolic, diastolic: diastolic, timestamp: timestamp))
                                    newRecord.HKUuid = uuid
                                    newRecord.arm = arm
                                    newRecord.position = position
                                    newRecord.stress = stress
                                    newRecord.notes = notes.isEmpty ? nil : notes
                                    newRecord.timeOfDay = timestamp.timeOfDay
                                    context.insert(newRecord)
                                }
                            }
                            
                            dismiss()
                        }
                        .buttonStyle(ProminentTomatoButton())
                        .padding(.vertical)
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
    }
}

struct TomatoButton: ButtonStyle {
    var selected = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 105, minHeight: 55, alignment: .center)
            .font(.system(size: 22, weight: .bold, design: .serif))
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.antiFlashWhite)
                    .shadow(color: .black.opacity(0.2), radius: 0, x: 0, y: 4)
            )
            .foregroundStyle(selected ? .tomato : .primary.opacity(0.6))
            .scaleEffect(selected ? 1.0 : 0.9)
    }
}

#Preview {
    @Previewable @State var healthKitManager = HealthKitManager()
    BPEditor()
        .environment(healthKitManager)
}
