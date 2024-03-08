//
//  UserData.swift
//  Pillanner
//
//  Created by 윤규호 on 2/27/24.
//

import Foundation
import FirebaseFirestore

struct UserData {
    var ID: String
    let password: String
    var name: String
    var phoneNumber: String
    var mealTime: [String]
}

struct Pill {
    let title: String
    let type: String // 일반 or 처방
    var day: [Int] // 일요일 ->0, 월요일 ->0 고려해봐야됨 [0~6]
    var dueDate: String // 데이터 타입 변화할 가능성이 있음...
    var intake: [String]
    var dosage: Double
}
