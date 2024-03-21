//  NotificationHelper.swift
//  Pillanner
//
//  Created by Joseph on 3/13/24.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseFirestore

class NotificationHelper {
    static let shared = NotificationHelper()

    private init() { }

    let db = Firestore.firestore()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    private func convertToEnglishWeekday(_ day: String) -> Int? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = "EEE"
        if let date = formatter.date(from: day) {
            return Calendar.current.component(.weekday, from: date)
        }
        return nil
    }

    // 사용자의 약 정보 읽어와 약 만료일에 대한 알림 예약
    func readUserPills() {
//        guard let userUID = UserDefaults.standard.string(forKey: "UID") else {
//            print("UserDefaults에 User UID 값 없음.")
//            return
//        }
//        DataManager.shared.readPillListData(UID: userUID) { pillsData in
//            guard let pillsData = pillsData else {
//                print("약 데이터 가져오기 실패")
//                return
//            }
//            print ("데이터 가져옴")
//            let pills = self.fetchPills(from: pillsData)
//
//            for pill in pills {
//                self.notificationForPillIntakeTime(pill)
//                self.notificationForPillDueDate(pill)
//            }
//        }
        guard let userUID = Auth.auth().currentUser?.uid else {
            print("Firebase에 사용자가 로그인되어 있지 않습니다.")
            return
        }
        print("User UID: \(userUID)")

        // Firestore에서 사용자 Pills 정보 가져오기
        db.collection("Users").document(userUID).collection("Pills").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("Pills 가져오기 에러: \(error)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("documents 없음")
                return
            }

            let pillsData = documents.map { $0.data() }

            let pills = self.fetchPills(from: pillsData)

            for pill in pills {
                self.notificationForPillIntakeTime(pill)
                self.notificationForPillDueDate(pill)
            }
        }
    }

    // 약 복용 시간 10분 전 알림
    private func notificationForPillIntakeTime(_ pill: Pill) {
        for day in pill.day {
            guard let weekday = convertToEnglishWeekday(day), weekday == Calendar.current.component(.weekday, from: Date()) else {
                continue
            }

            // 해당 요일에 해당하는 복용 시간들 가져옴
            var intakeTimes: [DateComponents] = []
            for intakeTime in pill.intake {
                if let components = convertStringToDate(intakeTime) {
                    intakeTimes.append(components)
                }
            }

            for intakeTime in intakeTimes {
                let notificationDate = calculateNotificationDate(for: intakeTime)

                // 약 만료일이 현재 날짜보다 이후인지
                guard let dueDate = dateFormatter.date(from: pill.dueDate), dueDate > Date() else {
                    continue
                }

                let title = "약 복용 알림"
                let body = "\(pill.title) 복용 10분 전입니다!"
                let identifier = "복용_\(pill.title)"

                scheduleNotification(title: title, body: body, date: notificationDate, identifier: identifier)
            }
        }
    }


    // 약 만료일 일주일 전 알림
    private func notificationForPillDueDate(_ pill: Pill) {
        guard let dueDate = dateFormatter.date(from: pill.dueDate) else { return }

        if dueDate > Date() {
            let title = "약 만료 알림"
            let body = "\(pill.title)이 곧 만료됩니다!"

            let triggerHour = 12
            let triggerMinute = 0
            var triggerDate = Calendar.current.date(bySettingHour: triggerHour, minute: triggerMinute, second: 0, of: dueDate)!
            triggerDate = Calendar.current.date(byAdding: .day, value: -7, to: triggerDate)! // 만료일 일주일 전 알림

            let identifier = "만료일_\(pill.title)"

            scheduleNotification(title: title, body: body, date: triggerDate, identifier: identifier)
        }
    }

}


// MARK: - Extension

extension NotificationHelper {

    // 알림 권한 설정
    func setAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in }
    }

    private func scheduleNotification(title: String, body: String, date: Date, identifier: String) {
        // 알림 내용
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        // 조건
        let triggerComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)
        // 요청
        let request = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: trigger)
        // 알림 등록
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }

    private func fetchPills(from data: [[String: Any]]) -> [Pill] {
        var pills: [Pill] = []
        for pillData in data {
            print("=====================")
            print("파싱된 데이터:", data)
            print("=====================")
            if let title = pillData["Title"] as? String,
               let type = pillData["Type"] as? String,
               let day = pillData["Day"] as? [String],
               let dueDate = pillData["DueDate"] as? String,
               let intake = pillData["Intake"] as? [String],
               let dosage = pillData["Dosage"] as? String,
               let alarmStatus = pillData["AlarmStatus"] as? Bool,
               alarmStatus == true {
                let pill = Pill(title: title, type: type, day: day, dueDate: dueDate, intake: intake, dosage: dosage, alarmStatus: alarmStatus)
                pills.append(pill)
            }
        }
        return pills
    }

    // 시간 문자열을 DateComponents로 변환
    private func convertStringToDate(_ timeString: String) -> DateComponents? {
        guard let date = timeFormatter.date(from: timeString) else {
            return nil
        }
        return Calendar.current.dateComponents([.hour, .minute], from: date)
    }

    // 복용 시간 기준으로 알림 날짜 계산
    private func calculateNotificationDate(for intakeComponents: DateComponents) -> Date {
        let calendar = Calendar.current

        guard let currentDate = calendar.date(bySettingHour: intakeComponents.hour!, minute: intakeComponents.minute!, second: 0, of: Date()),
              let notificationDate = calendar.date(byAdding: .minute, value: -10, to: currentDate) else {    // intake 시간에서 10분 전의 시간 계산
            fatalError("오류 발생")
        }
        return notificationDate
    }
}
