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
import Firebase
import FirebaseFirestore

class CalendarViewController: UIViewController {
    private lazy var gradientLayer = CAGradientLayer.dayBackgroundLayer(view: view)

    let db = Firestore.firestore()

    var isWeeklyMode: Bool = true
    private let sidePadding: CGFloat = 20
    private let cellHeight: CGFloat = 90
    private let cellSpacing: CGFloat = 10

    private var listOfPills = [Pill]()
    private var categoryOfPills = [PillCategory]()

    private var selectedCells: [IndexPath] = []
    
    // MARK: - Properties

    let calendar: FSCalendar = {
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

    let chevronImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.down"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .pointThemeColor2
        imageView.contentMode = .scaleAspectFit
        imageView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        return imageView
    }()

    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        return tableView
    }()

    lazy var refreshControl: UIRefreshControl = {
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
        showInitialAlert()
        setupCalendar()
        setupTableView()
        setupConstraint()
        setupSwipeGesture()
        setupRefreshControl()

        UserDefaults.standard.removeObject(forKey: "SelectedCells")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 테스트
        setUpPillData()
    }

    // MARK: - Setup

    // Pill List 만드는 순서 (viewWillAppear 함수 내부에 구현하기)
    // 1. Firestore에 저장된 Pill Data들 싹다 불러오기
    // 2. Pill -> duedate가 가지고 있는 날짜 데이터를 현재 날짜와 비교해서 유효한 데이터만 구별해내기
    // 3. Pill -> intake 정보에 따라 오전에 먹는 약인지, 오후에 먹는 약인지 분류
    // 4. 분류된 결과를 가지고, PillCategories 변수에 담아내기 ( PillCategories = [PillCategory] 타입의 배열 )
    // 5. 정의된 PillCategories 변수로 테이블 셀을 그려내기
    func setUpPillData() {
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
                                            dosageUnit: pill["DosageUnit"] as? String ?? "fdosageUnit",
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
                                                  dosageUnit: pill.dosageUnit,
                                                  alarmStatus: pill.alarmStatus))
                } else {
                    pillsListAM.pills.append(Pill(title: pill.title,
                                                  type: pill.type,
                                                  day: pill.day,
                                                  dueDate: pill.dueDate,
                                                  intake: [time],
                                                  dosage: pill.dosage,
                                                  dosageUnit: pill.dosageUnit,
                                                  alarmStatus: pill.alarmStatus))
                }
            }
        }
        pillsListAM.pills.sort { $0.intake[0] < $1.intake[0] }
        pillsListPM.pills.sort { $0.intake[0] < $1.intake[0] }
        let combinedCategories = [pillsListAM, pillsListPM]
        categoryOfPills = combinedCategories
        self.readTakenPills()
    }

    // 복용한 약들 가져와서 비교 후 셀 선택 상태로
    func readTakenPills() {
        guard let userUID = UserDefaults.standard.string(forKey: "UID") else {
            print("UserDefaults에서 UID를 찾을 수 없습니다.")
            return
        }
        print("User UID: \(userUID)")

        // Firestore에서 사용자 TakenPills 정보 가져오기
        db.collection("Users").document(userUID).collection("TakenPills").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print("TakenPills 가져오기 에러: \(error)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                print("documents 없음")
                return
            }

            let pillsData = documents.map { $0.data() }

            self.handleTakenPillsData(pillsData)
        }
    }
    private func handleTakenPillsData(_ pillsData: [[String: Any]]) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDateAsString = dateFormatter.string(from: Date())

        // 복용한 약물에 해당하는 셀을 선택 상태로 설정
        for (sectionIndex, category) in categoryOfPills.enumerated() {
            for (rowIndex, pill) in category.pills.enumerated() {
                // 각 셀에 대해 복용한 약물이 포함되어 있는지 확인하고, 포함되어 있다면 해당 셀을 선택 상태로 설정
                let pillDataExists = pillsData.contains { data in
                    return data["Title"] as? String == pill.title &&
                           data["TakenDate"] as? String == currentDateAsString &&
                           data["Intake"] as? String == pill.intake[0] &&
                           data["Dosage"] as? String == pill.dosage
                }
                print("=====================================================================")
                print("복용한 약 : ", pillsData)
                print("복용한 약과 일치하는 약 : ", pillDataExists)
                print("=====================================================================")
                if pillDataExists {
                    let indexPath = IndexPath(row: rowIndex, section: sectionIndex)
                    // Firebase에서 가져온 데이터와 테이블 뷰의 데이터를 비교하여 선택 상태를 설정
//                    if let index = listOfPills.firstIndex(where: { $0.title == pill.title && $0.intake == pill.intake && $0.dosage == pill.dosage }) {
//                        print("index : ", index)
//                        let updatedIndexPath = IndexPath(row: index, section: sectionIndex)
//                        tableView.selectRow(at: updatedIndexPath, animated: false, scrollPosition: .none)
////                        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
//                    }
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
            }
        }
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

    // MARK: - 테이블뷰 셋업

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

    // MARK: - 테이블뷰 헤더

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

}

// MARK: - Extension

extension CalendarViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: UITableView DataSource

    // 셀
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! CheckPillCell
        let pill = categoryOfPills[indexPath.section].pills[indexPath.row]

        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        cell.configure(with: pill)

        return cell
    }

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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }

    // MARK: - UITableView Delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

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

    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // 선택 상태 유지
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }

}
