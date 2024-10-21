//
//  BPRecord.swift
//  Arterio
//
//  Created by Roland Kajatin on 16/08/2024.
//

import Foundation
import SwiftData

@Model
class BPRecord {
    var HKUuid: UUID
    var record: HKBloodPressureRecord?
    var position: Position?
    var arm: Arm?
    var timeOfDay: TimeOfDay?
    var stress: Stress?
    var notes: String?
    
    init(record: HKBloodPressureRecord) {
        self.HKUuid = record.uuid
        self.record = record
    }
}

enum Position: String, Codable, Equatable, CaseIterable {
    case lying
    case sitting
    case standing
}

enum Arm: String, Codable, Equatable, CaseIterable {
    case left
    case right
}

enum TimeOfDay: Codable, Equatable {
    case morning
    case afternoon
    case evening
    case night
}

enum Stress: String, Codable, Equatable, CaseIterable {
    case low
    case medium
    case high
}

extension Date {
    var timeOfDay: TimeOfDay {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        
        switch hour {
        case 5..<12:
            return .morning
        case 12..<18:
            return .afternoon
        case 18..<22:
            return .evening
        default:
            return .night
        }
    }
}
