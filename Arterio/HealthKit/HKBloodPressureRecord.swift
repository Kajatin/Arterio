//
//  HKBloodPressureRecord.swift
//  Arterio
//
//  Created by Roland Kajatin on 18/08/2024.
//

import Foundation

struct HKBloodPressureRecord: Codable {
    var uuid: UUID
    var systolic: Double
    var diastolic: Double
    var timestamp: Date
}
