//  NotificationHelper.swift
//  Pillanner
//
//  Created by Joseph on 3/13/24.
//

import UIKit
import UserNotifications

class NotificationHelper {
    static let shared = NotificationHelper()

    private init() { }

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
//    func readUserPills() {
//        guard let userUID = UserDefaults.standard.string(forKey: "UID") else {
//            print("UserDefaults에 User UID 값 없음.")
//            return
//        }
//        DataManager.shared.readPillListData(UID: userUID) { pillsData in
//            guard let pillsData = pillsData else {
//                print("약 데이터 가져오기 실패")
//                return
//            }
//            let pills = self.fetchPills(from: pillsData)
//
//            for pill in pills {
//                self.notificationForPillIntakeTime(pill)
//                self.notificationForPillDueDate(pill)
//            }
//        }
//    }

    func readUserPills() {
        let dummyData: [[String: Any]] = [
            ["Title": "약 1", "Type": "일반", "Day": ["Mon", "Tue"], "DueDate": "2024-04-10", "Intake": ["12:55", "18:55"], "Dosage": 1.0],
            ["Title": "약 2", "Type": "처방", "Day": ["Wed", "Sun"], "DueDate": "2024-03-18", "Intake": ["20:50", "18:54"], "Dosage": 2.0]
        ]
        let pills = self.fetchPills(from: dummyData)

        for pill in pills {
            self.notificationForPillIntakeTime(pill)
            self.notificationForPillDueDate(pill)
        }
    }

    // 약 복용 시간 10분 전 알림
    private func notificationForPillIntakeTime(_ pill: Pill) {
        let today = Calendar.current.component(.weekday, from: Date())

        // 오늘 요일에 해당하는 복용 시간 필터링
        for (index, intakeTime) in pill.intake.enumerated() {
            let intakeDay = pill.day[index % pill.day.count]
            guard let weekday = convertToEnglishWeekday(intakeDay), weekday == today else {
                continue
            }

            guard let intakeComponents = convertStringToDate(intakeTime),
                  let dueDate = dateFormatter.date(from: pill.dueDate) else {
                continue
            }

            // 알림 예약
            let title = "약 복용 알림"
            let body = "\(pill.title) 복용 10분 전"
            let triggerDate = calculateNotificationDate(for: intakeComponents)    // 현재 시간을 기준으로 intake 시간 10분 전 계산
            let identifier = "복용_\(pill.title)_\(intakeTime)"

            self.scheduleNotification(title: title, body: body, date: triggerDate, identifier: identifier)
        }
    }

    // 약 만료일 하루 전 알림
    private func notificationForPillDueDate(_ pill: Pill) {
        guard let dueDate = dateFormatter.date(from: pill.dueDate) else { return }

        if dueDate > Date() {
            let title = "약 만료 알림"
            let body = "\(pill.title)이 내일 만료됩니다!"

            let triggerHour = 19
            let triggerMinute = 20
            var triggerDate = Calendar.current.date(bySettingHour: triggerHour, minute: triggerMinute, second: 0, of: dueDate)!
            triggerDate = Calendar.current.date(byAdding: .day, value: -1, to: triggerDate)! // 만료일 하루 전 알림

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
            if let title = pillData["Title"] as? String,
               let type = pillData["Type"] as? String,
               let day = pillData["Day"] as? [String],
               let dueDate = pillData["DueDate"] as? String,
               let intake = pillData["Intake"] as? [String],
               let dosage = pillData["Dosage"] as? Double {
                let pill = Pill(title: title, type: type, day: day, dueDate: dueDate, intake: intake, dosage: dosage)
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
