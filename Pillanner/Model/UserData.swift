//
//  UserData.swift
//  Pillanner
//
//  Created by 윤규호 on 2/27/24.
//

import Foundation
import FirebaseFirestore

// 아래 구조체를 사용해서 회원 정보 함수에 입력할 수 있도록 만들어 두었습니다...
struct UserData {
    let UID: String
    var ID: String
    let password: String
    var nickname: String
}

struct Pill {
    let title: String
    let type: String // 일반 or 처방
    var day: [String] // 영문 3글자 Mon, Tue, Wed, Thu, Fri, Sat, Sun
    var dueDate: String // 데이터 타입 변화할 가능성이 있음...
    var intake: [String] // [10:30, 12:30]
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

enum Weekday: String {
    case Mon = "Mon"
    case Tue = "Tue"
    case Wed = "Wed"
    case Thu = "Thu"
    case Fri = "Fri"
    case Sat = "Sat"
    case Sun = "Sun"
}
