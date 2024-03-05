//
//  CalendarViewController.swift
//  Pillanner
//
//  Created by 영현 on 2/22/24.
//

import UIKit
import SnapKit
import FSCalendar
import UserNotifications

class CalendarViewController: UIViewController {

    private var isWeeklyMode: Bool = true
    private let sidePadding: CGFloat = 20
    private let cellHeight: CGFloat = 80
    private let cellSpacing: CGFloat = 10

    var medicationSections: [MedicationSection] = [
        MedicationSection(headerTitle: "아침 식후", medications: [
            Medicine(name: "약1", dosage: "1정", imageName: "pill"),
            //Medicine(name: "약1", dosage: "1정", imageName: "pill"),
        ]),
        MedicationSection(headerTitle: "점심 식후", medications: [
            Medicine(name: "약2", dosage: "1정", imageName: "pill"),
            Medicine(name: "약2", dosage: "1정", imageName: "pill"),
            Medicine(name: "약2", dosage: "1정", imageName: "pill"),
            Medicine(name: "약2", dosage: "1정", imageName: "pill"),
        ]),
    ]

    // MARK: - Properties

    private let calendar: FSCalendar = {
        let calendar = FSCalendar(frame: .zero)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.scope = .week
        calendar.appearance.headerDateFormat = "YYYY년 MM월"
        //calendar.appearance.headerTitleAlignment = .left
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.weekdayTextColor = .black
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.appearance.todayColor = .pointThemeColor2
        return calendar
    }()

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()

    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .pointThemeColor2
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()

    private struct Constants {
        static let cellIdentifier = "Cell"
        static let sectionHeaderHeight: CGFloat = 50
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let gradientLayer = CAGradientLayer.dayBackgroundLayer(view: view)
        view.layer.addSublayer(gradientLayer)

        UNUserNotificationCenter.current().delegate = self

        // 앱 시작 시 알림 권한 요청
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("알림 권한이 허용되었습니다.")
            } else {
                print("알림 권한이 거부되었습니다.")
            }
        }

        setupCalendar()
        setupTableView()
        setupConstraint()
        setupSwipeGesture()
        setupRefreshControl()
    }

    // MARK: - Setup

    private func setupCalendar() {
        view.addSubview(calendar)
        calendar.delegate = self
        calendar.dataSource = self
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        tableView.allowsMultipleSelection = true
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(CheckPillCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        tableView.separatorStyle = .none

        tableView.layer.cornerRadius = 20
        tableView.layer.masksToBounds = true
    }

    // MARK: - Constraint

    private func setupConstraint() {
        calendar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(sidePadding)
            $0.height.equalTo(600)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(calendar.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(sidePadding)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }

    // MARK: - Animation

    private func showFireworkAnimation(at position: CGPoint) {
        let emitter = CAEmitterLayer()
        //emitter.emitterPosition = position
        emitter.emitterPosition = CGPoint(x: position.x, y: view.frame.height)
        emitter.emitterShape = .point
        emitter.emitterSize = CGSize(width: 10, height: 10)

        let cell = CAEmitterCell()
        cell.contents = UIImage(named: "firework2")?.cgImage
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

    // MARK: - Swipe Gesture

    private func setupSwipeGesture() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }

    @objc private func handleSwipe(_ swipe: UISwipeGestureRecognizer) {
        if swipe.direction == .up {
            calendar.appearance.headerTitleFont = .systemFont(ofSize: 17)
            calendar.setScope(.week, animated: true)
        } else if swipe.direction == .down {
            calendar.appearance.headerTitleFont = .boldSystemFont(ofSize: 20)
            calendar.setScope(.month, animated: true)
        }
    }

    // MARK: - Refresh Control

    private func setupRefreshControl() {
        tableView.refreshControl = refreshControl
    }

    @objc private func handleRefresh(_ sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            sender.endRefreshing()
        }
    }
}

// MARK: - Extension

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource, UITableViewDataSource, UITableViewDelegate, UNUserNotificationCenterDelegate {

    // MARK: FSCalendar Delegateㅎ

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

    // MARK: UITableView DataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return medicationSections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicationSections[section].medications.count
    }

    // 테이블 뷰 헤더
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear

        let titleLabel = UILabel()
        titleLabel.text = medicationSections[section].headerTitle
        titleLabel.textColor = .black
        titleLabel.font = FontLiteral.title3(style: .bold)

        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(20)
        }

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.sectionHeaderHeight
    }

    // 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! CheckPillCell
        let medicine = medicationSections[indexPath.section].medications[indexPath.row]

        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.configure(with: medicine)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }

    // MARK: - UITableView Delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows, selectedIndexPaths.count == medicationSections.flatMap({ $0.medications }).count {
            showFireworkAnimation(at: tableView.center)
        }

        // 알림
        let medicine = medicationSections[indexPath.section].medications[indexPath.row]
        showNotification(message: "\(medicine.name) - \(medicine.dosage)을 복용하셨습니다.")
    }

    // MARK: - UserNotification

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }

    private func showNotification(message: String) {
           let content = UNMutableNotificationContent()
           content.title = "알림"
           content.body = message
           content.sound = UNNotificationSound.default

           let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)

           UNUserNotificationCenter.current().add(request) { error in
               if let error = error {
                   print("알림 요청이 실패했습니다. 오류: \(error.localizedDescription)")
               }
           }
       }
}
