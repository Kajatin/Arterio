//
//  BPEditor.swift
//  Arterio
//
//  Created by Roland Kajatin on 19/08/2024.
//

import SwiftUI

enum MeasurementStage {
    case first
    case second
    case third
    case basics
}

struct BPEditor: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Environment(HealthKitManager.self) private var healthKitManager
    
    @State var stage: MeasurementStage = .first
    
    @State var arm = Arm.left
    @State var position = Position.sitting
    @State var stress = Stress.low
    
    @State var systolic1: Double = 120
    @State var diastolic1: Double = 80
    @State var systolic2: Double = 120
    @State var diastolic2: Double = 80
    @State var skipped2: Bool = false
    @State var systolic3: Double = 120
    @State var diastolic3: Double = 80
    @State var skipped3: Bool = false
    
    @State var notes = ""
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.tomato
                .ignoresSafeArea()
            
            VStack(spacing: 28) {
                Text("Measurement")
                    .font(.system(size: 44, weight: .bold, design: .serif))
                    .foregroundStyle(.antiFlashWhite)
                    .padding(.top)
                
                HStack {
                    Button {
                        switch stage {
                        case .second:
                            stage = .first
                        case .third:
                            stage = .second
                        case .basics:
                            stage = .third
                        default:
                            stage = .first
                        }
                    } label: {
                        Image(systemName: "arrowshape.backward.fill")
                            .font(.system(size: 34, weight: .bold, design: .serif))
                            .foregroundStyle(.antiFlashWhite)
                    }
                    .opacity(stage == .first ? 0 : 1)
                    
                    Spacer()
                    
                    Image(systemName: stage == .first ? "1.square.fill" : stage == .second ? "2.square.fill" : "3.square.fill")
                        .font(.system(size: 40, weight: .bold, design: .serif))
                        .foregroundStyle(.antiFlashWhite)
                        .opacity(stage == .basics ? 0 : 1)
                    
                    Spacer()
                    
                    Image(systemName: "arrowshape.backward")
                        .font(.system(size: 34, weight: .bold, design: .serif))
                        .foregroundStyle(.antiFlashWhite)
                        .opacity(0)
                }
                .padding(.horizontal)
                
                Spacer()
                
                switch stage {
                case .first:
                    BPMeasurements(systolic: $systolic1, diastolic: $diastolic1)
                case .second:
                    BPMeasurements(systolic: $systolic2, diastolic: $diastolic2)
                case .third:
                    BPMeasurements(systolic: $systolic3, diastolic: $diastolic3)
                case .basics:
                    BPBasics(arm: $arm, position: $position, stress: $stress)
                }
                
                Spacer()
                
                VStack {
                    Button(stage == .basics ? "Save" : "Continue") {
                        if stage == .basics {
                            Task {
                                let averageSystolic = (systolic1 + (skipped2 ? 0 : systolic2) + (skipped3 ? 0 : systolic3)) / (skipped2 && skipped3 ? 1 : skipped2 || skipped3 ? 2 : 3)
                                let averageDiastolic = (diastolic1 + (skipped2 ? 0 : diastolic2) + (skipped3 ? 0 : diastolic3)) / (skipped2 && skipped3 ? 1 : skipped2 || skipped3 ? 2 : 3)
                                
                                let newMeasurement = await healthKitManager.saveBloodPressureMeasurement(systolic: averageSystolic, diastolic: averageDiastolic)
                                
                                if let uuid = newMeasurement?.uuid, let timestamp = newMeasurement?.startDate {
                                    let newRecord = BPRecord(record: HKBloodPressureRecord(uuid: uuid, systolic: systolic1, diastolic: diastolic1, timestamp: timestamp))
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
                        } else {
                            switch stage {
                            case .first:
                                stage = .second
                            case .second:
                                stage = .third
                            case .third:
                                stage = .basics
                            default:
                                stage = .basics
                            }
                        }
                    }
                    .buttonStyle(ProminentTomatoButton())
                    .padding(.vertical)
                    
                    Button {
                        if stage == .second {
                            skipped2 = true
                            stage = .third
                        } else if stage == .third {
                            skipped3 = true
                            stage = .basics
                        }
                    } label: {
                        Text("Skip")
                    }
                    .font(.system(size: 20, weight: .bold, design: .serif))
                    .foregroundStyle(.antiFlashWhite)
                    .opacity(stage == .second || stage == .third ? 1 : 0)
                }
            }
            .padding(.bottom)
        }
    }
}

struct BPMeasurements: View {
    @Binding var systolic: Double
    @Binding var diastolic: Double
    
    var body: some View {
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
    }
}

struct BPBasics: View {
    @Binding var arm: Arm
    @Binding var position: Position
    @Binding var stress: Stress
    
    var body: some View {
        VStack(spacing: 24) {
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
