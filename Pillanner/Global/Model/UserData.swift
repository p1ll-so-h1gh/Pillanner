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
    var signUpPath: String
}

// 약을 저장할 때 하루에 섭취하는 횟수를 넣어도 좋지 않을까
// intake의 개수, 즉 setting에서 복용횟수 추가할 때 count값으로 한번 넣어주기? dailyIntakeCount 이는 intake.count랑 동일할듯 그냥 함수 하나 만들어서 넣어줘도 좋을 듯 func countDailyIntakeNumber/Times()
struct Pill: Equatable {
    let title: String
    let type: String // 일반 or 처방
    var day: [String] // 영문 3글자 Mon, Tue, Wed, Thu, Fri, Sat, Sun
    var dueDate: String // 데이터 타입 변화할 가능성이 있음...
    var intake: [String] // [10:30, 12:30]
    var dosage: String
    var alarmStatus: Bool
}

struct PillCategory: Equatable {
    static func == (lhs: PillCategory, rhs: PillCategory) -> Bool {
        guard lhs.meridiem == rhs.meridiem else { return false }
        guard lhs.pills == rhs.pills else { return false }
        return true
    }
    
    var meridiem: String
    var pills: [Pill]
}


struct TakenPill {
    let title: String
    var takenDate: String
    var intake: String
    var dosage: String
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

// DosageAddViewController / IntakeSetting 데이터 모델 정의
struct IntakeData {
    var time: String // "HH:mm" 포맷
    var dosage: String // 예: "2 정"
    var isAlarmOn: Bool
}
