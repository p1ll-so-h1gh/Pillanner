//
//  Model.swift
//  ExCalendar
//
//  Created by Joseph on 2/26/24.
//

import Foundation

struct MedicationSection {
    var headerTitle: String
    var medications: [Medicine]
}

struct Medicine {
    var name: String
    var dosage: String
    var time: String
    var type: String
}
