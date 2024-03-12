//
//  UserData.swift
//  Pillanner
//
//  Created by 윤규호 on 2/27/24.
//

import Foundation
import FirebaseFirestore

struct UserData {
    let UID: String
    var ID: String
    let password: String
    var nickname: String
}

struct Pill {
    let title: String
    let type: String // 일반 or 처방
    var day: [Int] // 일요일 -> 0
    var dueDate: String // 데이터 타입 변화할 가능성이 있음...
    var intake: [String]
    var dosage: Double
}

struct PillCategory {
    var meridiem: String
    var pills: [Pill]
}

struct TakenPill {
    let title: String
    let type: String // 일반 or 처방
    var takenDate: String // 데이터 타입 변화할 가능성이 있음...
    var intake: [String]
    var dosage: Double
    var dosed: Bool
}

struct TakenPillsCategory {
    var meridiem: String
    var pills: [TakenPill]
}
