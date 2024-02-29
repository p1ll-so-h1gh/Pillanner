//
//  UserData.swift
//  Pillanner
//
//  Created by 윤규호 on 2/27/24.
//

import Foundation
import FirebaseFirestore

struct UserData {
    let ID: String
    let password: String
    let name: String
    let phoneNumber: String
    var mealTime: [String]
}

struct Pill {
    let title: String
    let type: String
    var day: [Int]
    var dueDate: Date
    var intake: [Intake]
}

struct Intake {
    var time: DateFormatter
    var numberOfPills: Int
}
