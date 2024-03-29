
//  InitialSetUpViewController.swift
//  Pillanner
//
//  Created by 영현 on 2/22/24.

import UIKit
import SnapKit

class InitialSetUpViewController: UIViewController {
    
    private var titleForAdd = String()
    private var typeForAdd = String()
    private var dayForAdd = [String]()
    private var dueDateForAdd = String()
    private var intakeForAdd = [String]()
    private var dosageForAdd = String()
    private var alarmStatusForAdd = Bool()
    
    private var alarmStatus: Bool = false
    private var timeData: String = ""
    private var dosage: String = ""
    private var dosageUnitForAdd: String = ""
    
    private let sidePaddingSizeValue = 20
    private let cornerRadiusValue: CGFloat = 13
    private var count = 1
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = FontLiteral.largeTitle(style: .bold).withSize(25)
        label.textColor = UIColor.pointThemeColor2
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontLiteral.largeTitle(style: .bold).withSize(25)
        label.text = "번째 약의 정보를 입력해주세요"
        return label
    }()
    
    private let totalTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PillCell.self, forCellReuseIdentifier: PillCell.identifier)
        tableView.register(AlarmCell.self, forCellReuseIdentifier: AlarmCell.identifier)
        tableView.register(IntakeNumberCell.self, forCellReuseIdentifier: IntakeNumberCell.identifier)
        tableView.register(IntakeDateCell.self, forCellReuseIdentifier: IntakeDateCell.identifier)
        tableView.register(IntakeSettingCell.self, forCellReuseIdentifier: IntakeSettingCell.identifier)
        tableView.register(PillTypeCell.self, forCellReuseIdentifier: PillTypeCell.identifier)
        tableView.register(DueDateCell.self, forCellReuseIdentifier: DueDateCell.identifier)
        return tableView
    }()
    
    private lazy var addButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.pointThemeColor2
        view.layer.cornerRadius = cornerRadiusValue
        return view
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("등록하기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    private lazy var navigationBackButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        numberLabel.text = "\(count)"
        
        self.totalTableView.dataSource = self
        self.totalTableView.delegate = self
        self.totalTableView.rowHeight = UITableView.automaticDimension
        
        addButton.addTarget(self, action: #selector(addPill), for: .touchUpInside)
        
        navigationBackButton.tintColor = .black
        self.navigationItem.backBarButtonItem = navigationBackButton
        
        setupView()
    }
    
    //뷰가 나타날 때 네비게이션 바 숨김
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //키보드 외부 터치 시 키보드 숨김처리
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 키보드 리턴 버튼 누를경우 키보드 숨김처리
    func textFieldShouldReturn(_ textField: UITextField) {
        if let pillCell = self.totalTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PillCell {
            pillCell.hideKeyboard()
        }
    }
    
    @objc func addPill() {
        // 데이터 저장( firestore )
        DataManager.shared.createPillData(pill: Pill(title: self.titleForAdd, type: self.typeForAdd, day: self.dayForAdd, dueDate: self.dueDateForAdd, intake: self.intakeForAdd, dosage: self.dosageForAdd, dosageUnit: self.dosageUnitForAdd, alarmStatus: self.alarmStatusForAdd))
        // 약을 더 추가할 때 나오는 얼럿 설정
        let title = "추가적으로 등록할 약이 있을까요?"
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        //addAdditionalPill 시 서버에 약 저장, 화면 초기화, count 증가
        let addAdditionalPillAction = UIAlertAction(title: "네", style: .default) { _ in
            self.count += 1
            //            self.resetInputValue()
            self.numberLabel.text = "\(self.count)"
            self.resetEveryCellsInView()
            self.totalTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
        }
        //finish 시 약 정보 입력 페이지 나가고 InitialSetUpEndVC로 이동
        let finish = UIAlertAction(title: "아니요", style: .default) { _ in
            let initialSetUpEndVC = InitialSetupEndViewController()
            self.navigationController?.pushViewController(initialSetUpEndVC, animated: true)
        }
        alert.addAction(addAdditionalPillAction)
        alert.addAction(finish)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupView() {
        addButtonView.addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.top.bottom.leading.trailing.centerX.centerY.equalToSuperview()
        }
        [numberLabel, titleLabel, totalTableView, addButtonView].forEach {
            view.addSubview($0)
        }
        numberLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(sidePaddingSizeValue*2)
            $0.leading.equalTo(sidePaddingSizeValue)
        }
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(numberLabel.snp.centerY)
            $0.leading.equalTo(numberLabel.snp.trailing).inset(-5)
        }
        totalTableView.snp.makeConstraints {
            $0.top.equalTo(numberLabel.snp.bottom).inset(-10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(addButtonView.snp.top).inset(-sidePaddingSizeValue)
        }
        addButtonView.snp.makeConstraints {
            $0.width.equalTo(339)
            $0.height.equalTo(53)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
    
    // 화면 내부의 각 셀의 값들을 초기화해주는 메서드
    private func resetInputValue() {
        if let pillCell = self.totalTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PillCell {
            pillCell.reset()
        }
        if let IntakeDateCell = self.totalTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? IntakeDateCell {
            IntakeDateCell.reset()
        }
        if let IntakeSettingCell = self.totalTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? IntakeSettingCell {
            IntakeSettingCell.reset()
        }
        if let PillTypeCell = self.totalTableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? PillTypeCell {
            PillTypeCell.reset()
        }
        if let DeadlineCell = self.totalTableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? DueDateCell {
            DeadlineCell.reset()
        }
    }
    
    private func resetEveryCellsInView() {
        titleForAdd = ""
        typeForAdd = ""
        dayForAdd = []
        dueDateForAdd = ""
        intakeForAdd = []
        dosageForAdd = ""
        alarmStatusForAdd = false
        
        alarmStatus = false
        timeData = ""
        dosage = ""
        dosageUnitForAdd = ""
        self.totalTableView.reloadData()
    }
}



//MARK: - TableView DataSource, Delegate
extension InitialSetUpViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 각 인덱스에 따라 다른 커스텀 셀 반환
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PillCell", for: indexPath) as! PillCell
            cell.setupLayoutOnEditingProcess(title: self.titleForAdd)
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as! AlarmCell
            cell.setupLayoutOnEditingProcess(alarmStatus: self.alarmStatusForAdd)
            cell.delegate = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IntakeNumberCell", for: indexPath) as! IntakeNumberCell
            cell.setupLayoutOnEditingProcess(dosage: self.dosageForAdd, unit: self.dosageUnitForAdd)
            cell.delegate = self
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IntakeDateCell", for: indexPath) as! IntakeDateCell
            cell.setupLayoutOnEditingProcess(days: self.dayForAdd)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IntakeSettingCell", for: indexPath) as! IntakeSettingCell
            cell.setupLayoutOnEditingProcess(intake: self.intakeForAdd)
            cell.delegate = self
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PillTypeCell", for: indexPath) as! PillTypeCell
            cell.setupLayoutOnEditingProcess(type: self.typeForAdd)
            cell.delegate = self
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeadlineCell", for: indexPath) as! DueDateCell
            cell.setupLayoutOnEditingProcess(dueDate: self.dueDateForAdd)
            cell.delegate = self
            return cell
        default:
            fatalError("Invalid index path")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            let weekSelectVC = WeekdaySelectionViewController(selectedWeekdaysInString: self.dayForAdd)
            weekSelectVC.delegate = self
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.pushViewController(weekSelectVC, animated: true)
        }
    }
}

// DosageAddViewController 로 이동하기 위한 Delegate
extension InitialSetUpViewController: IntakeSettingDelegate {
    func addIntakeWithData() {
//        <#code#>
    }
    
    func addIntake() {
        let intakeAddVC = IntakeAddViewController()
        intakeAddVC.delegate = self
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(intakeAddVC, animated: true)
    }
}

extension InitialSetUpViewController: PillCellDelegate, AlarmCellDelegate,intakeNumberCellDelegate, IntakeDateCellDelegate, PillTypeCellDelegate ,DueDateCellDelegate, IntakeAddDelegate {
    func updateUnit(unit: String) {
        self.dosageUnitForAdd = unit
    }
    
    func updateAlarmStatus(status: Bool) {
        self.alarmStatusForAdd = status
    }
    
    func updateDataFromIntakeAddViewController(intake: String) {
        self.intakeForAdd.append(intake)
        self.totalTableView.reloadData()
    }
    
    func updateDays(_ days: [String]) {
        self.dayForAdd = days
        self.totalTableView.reloadData()
    }
    
    func updatePillTitle(_ title: String) {
        self.titleForAdd = title
    }
    
    func updatePillType(_ type: String) {
        self.typeForAdd = type
    }
    
    func updateDueDate(date: String) {
        self.dueDateForAdd = date
    }
    
    func updateDosage(dosage: String) {
        self.dosageForAdd = dosage
    }
    
    func updateIntake(_ intake: String) {
        self.intakeForAdd.append(intake)
    }
    
    func updateDueDateCellHeight() {
        self.totalTableView.reloadData()
        self.totalTableView.scrollToRow(at: IndexPath(row: 6, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
    }
}
