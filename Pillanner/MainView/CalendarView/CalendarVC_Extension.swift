//
//  CalendarVC_Extension.swift
//  Pillanner
//
//  Created by Joseph on 3/27/24.
//

import UIKit
import FSCalendar

// 캘린더, chevron, 새로고침, 애니메이션, 알림
extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, UNUserNotificationCenterDelegate {

    // MARK: - 초기 알림

    func showInitialAlert() {
        let alertMessage = "약을 복용한 후 \n 버튼을 눌러주세요❗️"

        let alertController = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)

        present(alertController, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                alertController.dismiss(animated: true, completion: nil)
            }
        }
    }

    // MARK: - 캘린더 셋업

    func setupCalendar() {
        view.addSubview(calendar)
        view.addSubview(chevronImage)
        calendar.delegate = self
        calendar.dataSource = self

        setupChevronTap()
    }

    // MARK: FSCalendar Delegate

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints {
            $0.height.equalTo(bounds.height)
        }

        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return false
    }

    // MARK: - 캘린더 스와이프

    func setupSwipeGesture() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }

    // 달력 스와이프
    @objc private func handleSwipe(_ swipe: UISwipeGestureRecognizer) {
        if swipe.direction == .up {
            calendar.appearance.headerTitleFont = .systemFont(ofSize: 17)
            calendar.setScope(.week, animated: true)
            chevronImage.image = UIImage(systemName: "chevron.down")
        } else if swipe.direction == .down {
            calendar.appearance.headerTitleFont = .boldSystemFont(ofSize: 20)
            calendar.setScope(.month, animated: true)
            chevronImage.image = UIImage(systemName: "chevron.up")
        }
    }

    // MARK: - Chevron

    func setupChevronTap() {
        let chevronTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleChevronTap))
        chevronImage.isUserInteractionEnabled = true
        chevronImage.addGestureRecognizer(chevronTapGesture)
    }

    // chevron 탭
    @objc private func handleChevronTap() {
        if isWeeklyMode {
            calendar.appearance.headerTitleFont = .boldSystemFont(ofSize: 20)
            calendar.setScope(.month, animated: true)
            chevronImage.image = UIImage(systemName: "chevron.up")
        } else {
            calendar.appearance.headerTitleFont = .systemFont(ofSize: 17)
            calendar.setScope(.week, animated: true)
            chevronImage.image = UIImage(systemName: "chevron.down")
        }

        isWeeklyMode = !isWeeklyMode
    }

    // MARK: - 새로고침

    func setupRefreshControl() {
        tableView.refreshControl = refreshControl
    }

    @objc func handleRefresh(_ sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            sender.endRefreshing()
        }

        //setUpPillData()
        readTakenPills()
    }

    // MARK: - 모두 선택 완료 시 Animation

    func showFireworkAnimation(at position: CGPoint) {
        let emitter = CAEmitterLayer()
        //emitter.emitterPosition = position
        emitter.emitterPosition = CGPoint(x: position.x, y: view.frame.height)
        emitter.emitterShape = .point
        emitter.emitterSize = CGSize(width: 10, height: 10)

        let cell = CAEmitterCell()
        cell.contents = UIImage(named: "firework")?.cgImage
        cell.birthRate = 10
        cell.lifetime = 3
        cell.velocity = -250
        cell.scale = 0.05
        cell.scaleRange = 0.4

        //cell.emissionRange = CGFloat.pi * 2
        cell.emissionRange = -CGFloat.pi / 6
        cell.emissionLongitude = CGFloat.pi / 2

        cell.spin = 0
        cell.spinRange = 10

        emitter.emitterCells = [cell]

        view.layer.addSublayer(emitter)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            emitter.removeFromSuperlayer()
        }
    }

    // MARK: - 셀 선택 알림 관련

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.alert, .sound, .badge]) // alert 가 iOS 14 이후로 deprecated되어 banner 타입으로 수정
        completionHandler([.sound, .badge, .banner])
    }

    func showNotification(message: String) {
        let content = UNMutableNotificationContent()
        content.body = message
        content.sound = .default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알림 요청이 실패했습니다. 오류: \(error.localizedDescription)")
            }
        }
    }
}
