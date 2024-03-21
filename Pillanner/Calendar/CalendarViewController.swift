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

protocol CalendarViewDelegate: AnyObject {
    //전체 복용 pill개수 저장함
    func sendTotalEvent(event: Int)
    //셀이 더 선택되어 복용이 바뀐 것을 알려줌
    func takenPillChanged()
}

class CalendarViewController: UIViewController {
    private lazy var gradientLayer = CAGradientLayer.dayBackgroundLayer(view: view)
    
    private var isWeeklyMode: Bool = true
    private let sidePadding: CGFloat = 20
    private let cellHeight: CGFloat = 90
    private let cellSpacing: CGFloat = 10
    
    private var listOfPills = [Pill]()
    private var categoryOfPills = [PillCategory]()
    private var selectedCells: [IndexPath] = []

    weak var delegate: CalendarViewDelegate?
    
    // MARK: - Properties
    
    private let calendar: FSCalendar = {
        let calendar = FSCalendar(frame: .zero)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.appearance.headerDateFormat = "YYYY년 MM월"
        calendar.scope = .week
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.weekdayTextColor = .black
        calendar.appearance.weekdayFont = .boldSystemFont(ofSize: 15)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.appearance.todayColor = .pointThemeColor2
        return calendar
    }()
    
    private let chevronImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.down"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .pointThemeColor2
        imageView.contentMode = .scaleAspectFit
        imageView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        return imageView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
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
        view.layer.addSublayer(gradientLayer)
        setupCalendar()
        setupTableView()
        setupConstraint()
        setupSwipeGesture()
        setupRefreshControl()
        loadSelectedCells()
        removeSelectedCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 테스트
        setUpPillData()
        print("##### categoryOfPills", categoryOfPills)
    }

    // MARK: - Setup
    
    // Pill List 만드는 순서 (viewWillAppear 함수 내부에 구현하기)
    // 1. Firestore에 저장된 Pill Data들 싹다 불러오기
    // 2. Pill -> duedate가 가지고 있는 날짜 데이터를 현재 날짜와 비교해서 유효한 데이터만 구별해내기
    // 3. Pill -> intake 정보에 따라 오전에 먹는 약인지, 오후에 먹는 약인지 분류
    // 4. 분류된 결과를 가지고, PillCategories 변수에 담아내기 ( PillCategories = [PillCategory] 타입의 배열 )
    // 5. 정의된 PillCategories 변수로 테이블 셀을 그려내기
    private func setUpPillData() {
        print(#function)
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
        
        let todaysDate = dateFormatter.date(from: Date().toString())
        let dayFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE" // Mon, Tue...
            formatter.locale = Locale(identifier: "en")
            return formatter
        }()
        
        let todaysday = dayFormatter.string(from: Date())
        var todaysPill = [Pill]()
        if let UID = UserDefaults.standard.string(forKey: "UID") {
            DataManager.shared.readPillListData(UID: UID) { list in
                guard let list = list else {
                    print("받아올 약의 데이터가 없습니다.")
                    return
                }
                
                // 복용 기한 지난 약들 거름망
                for pill in list {
                    if let dueDate = dateFormatter.date(from: pill["DueDate"] as! String) {
                        if todaysDate?.compare(dueDate).rawValue == 1 {
                            print("복용 기한이 지난 약의 데이터입니다.")
                        } else {
                            let data = Pill(title: pill["Title"] as? String ?? "ftitle",
                                            type: pill["Type"] as? String ?? "ftype",
                                            day: pill["Day"] as? [String] ?? ["fday"],
                                            dueDate: pill["DueDate"] as? String ?? "fduedate",
                                            intake: pill["Intake"] as? [String] ?? ["fintake"],
                                            dosage: pill["Dosage"] as? String ?? "fdosage",
                                            alarmStatus: pill["AlarmStatus"] as? Bool ?? true)
                            todaysPill.append(data)
                        }
                    }
                }
                
                var tempList = [Pill]()
                for pill in todaysPill { // 복용기한 내
                    if pill.day.contains(todaysday) {
                        tempList.append(pill) // "yyyy-MM-dd" 요일이 같음 -> 오늘 날짜의 yyyy-MM-dd
                        
                    }
                }
                self.listOfPills = tempList
                self.categorizePillData()
                self.tableView.reloadData()
            }
        }
    }
    
    
    private func categorizePillData() {
        print(#function)
        // 시간 변환하는 포매터 설정
        var pillsListAM = PillCategory(meridiem: "오전", pills: [])
        var pillsListPM = PillCategory(meridiem: "오후", pills: [])
        let timeFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            formatter.locale = Locale(identifier: "ko-KR")
            return formatter
        }()
        // 이중 for 문 없이 할 수 있는 방법이 있을까요
        // map, filter, reduce 로 간략하게 정리해볼 수도
        // reduce -> 반복문 돌리면서 append할 때 편리함
        for pill in listOfPills {
            for time in pill.intake {
                if timeFormatter.date(from: time)?.compare(timeFormatter.date(from: "12:00")!).rawValue == 1 {
                    pillsListPM.pills.append(Pill(title: pill.title,
                                                  type: pill.type,
                                                  day: pill.day,
                                                  dueDate: pill.dueDate,
                                                  intake: [time],
                                                  dosage: pill.dosage,
                                                  alarmStatus: pill.alarmStatus))
                } else {
                    pillsListAM.pills.append(Pill(title: pill.title,
                                                  type: pill.type,
                                                  day: pill.day,
                                                  dueDate: pill.dueDate,
                                                  intake: [time],
                                                  dosage: pill.dosage,
                                                  alarmStatus: pill.alarmStatus))
                }
            }
        }
        let combinedCategories = [pillsListAM, pillsListPM]
        self.delegate?.sendTotalEvent(event: pillsListAM.pills.count + pillsListPM.pills.count)
        categoryOfPills = combinedCategories
    }
    
    private func setupCalendar() {
        view.addSubview(calendar)
        view.addSubview(chevronImage)
        calendar.delegate = self
        calendar.dataSource = self
        
        setupChevronTap()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CheckPillCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        tableView.allowsMultipleSelection = true
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 20
        tableView.layer.masksToBounds = true
    }
    
    // MARK: - Constraint
    
    private func setupConstraint() {
        calendar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(sidePadding)
            $0.height.equalTo(550)
        }
        
        chevronImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(calendar.snp.bottom)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(chevronImage.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(sidePadding)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    // MARK: - 모두 선택 완료 시 Animation
    
    private func showFireworkAnimation(at position: CGPoint) {
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
    
    // MARK: - 캘린더 스와이프
    
    private func setupSwipeGesture() {
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
        } else if swipe.direction == .down {
            calendar.appearance.headerTitleFont = .boldSystemFont(ofSize: 20)
            calendar.setScope(.month, animated: true)
        }
        
        flipChevronImage()
    }
    
    // chevron 탭
    @objc private func handleChevronTap() {
        if isWeeklyMode {
            calendar.setScope(.month, animated: true)
        } else {
            calendar.setScope(.week, animated: true)
        }
        
        flipChevronImage()
        isWeeklyMode = !isWeeklyMode
    }
    
    // MARK: - Chevron
    
    private func setupChevronTap() {
        let chevronTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleChevronTap))
        chevronImage.isUserInteractionEnabled = true
        chevronImage.addGestureRecognizer(chevronTapGesture)
    }
    
    // chevron 뒤집는 애니메이션
    private func flipChevronImage() {
        UIView.transition(with: chevronImage, duration: 0.5, options: .transitionFlipFromBottom, animations: {
            self.chevronImage.transform = self.chevronImage.transform.scaledBy(x: 1, y: -1)
        }, completion: nil)
    }
    
    // MARK: - 테이블 뷰 헤더
    
    private func createHeaderView(for section: Int) -> UIView {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let headerTitle = UILabel()
        headerTitle.text = categoryOfPills[section].meridiem
        headerTitle.textColor = .black
        headerTitle.font = FontLiteral.title3(style: .bold)
        
        headerView.addSubview(headerTitle)
        headerTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(20)
        }
        return headerView
    }
    
    // MARK: - 새로고침
    
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

    // MARK: UITableView DataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return categoryOfPills.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryOfPills[section].pills.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createHeaderView(for: section)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.sectionHeaderHeight
    }

    // 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! CheckPillCell
        let pill = categoryOfPills[indexPath.section].pills[indexPath.row]

        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.configure(with: pill)

        // 셀 상태 업데이트
        if selectedCells.contains(indexPath) {
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            cell.setSelected(true, animated: false)
        } else {
            tableView.deselectRow(at: indexPath, animated: false)
            cell.setSelected(false, animated: false)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }

    // MARK: - UITableView Delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 선택된 셀의 IndexPath 추가
        selectedCells.append(indexPath)
        saveSelectedCells(indexPath)

        // 모두 선택 시
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows, selectedIndexPaths.count == categoryOfPills.flatMap({ $0.pills }).count {
            showFireworkAnimation(at: tableView.center)
        }

        // 알림
        let pill = categoryOfPills[indexPath.section].pills[indexPath.row]
        showNotification(message: "'\(pill.title) - \(pill.dosage)'을 복용하셨습니다.")

        // 셀 선택 시 복용된 약 저장
        // 날짜는 캘린더에 표시되는 당일 값을 넣어줌
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let takenPill = TakenPill(title: pill.title, takenDate: dateFormatter.string(from: calendar.today!), intake: pill.intake[0], dosage: pill.dosage)
        DataManager.shared.createPillRecordData(pill: takenPill)

        //복용 업데이트 사실 알려줌
        self.delegate?.takenPillChanged()
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // 선택 상태 유지
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }

    // MARK: - UserNotification

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }

    private func showNotification(message: String) {
        let content = UNMutableNotificationContent()
        //content.title = "알림"
        content.body = message
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("알림 요청이 실패했습니다. 오류: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - 선택된 셀 관련

    private func saveSelectedCells(_ indexPath: IndexPath) {
        var selectedIndexPaths = UserDefaults.standard.array(forKey: "SelectedCells") as? [[Int]] ?? []
        let indexPathArray = [indexPath.section, indexPath.row]
        selectedIndexPaths.append(indexPathArray)
        UserDefaults.standard.set(selectedIndexPaths, forKey: "SelectedCells")
    }
    private func loadSelectedCells() {
        if let selectedIndexPaths = UserDefaults.standard.array(forKey: "SelectedCells") as? [[Int]] {
            for indexPathArray in selectedIndexPaths {
                let indexPath = IndexPath(row: indexPathArray[1], section: indexPathArray[0])
                selectedCells.append(indexPath)
            }
        }
    }
    // 다음날이 되면 저장된 IndexPath 삭제
    private func removeSelectedCells() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        let currentTimeString = dateFormatter.string(from: Date())

        if currentTimeString >= "24:00" {
            selectedCells.removeAll()
            UserDefaults.standard.removeObject(forKey: "SelectedCells")
        }
    }
}
