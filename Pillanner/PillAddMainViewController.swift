//
//  PillAddMainViewController.swift
//  Pillanner
//
//  Created by 박민정 on 2/29/24.
//

import UIKit
import SnapKit

// 약 추가하는 부분에서는 다른 데이터 가져올 필요 없이, 반환되는 값들로 Pill 구조체 하나 뚝딱해서 만들어내야됨
// 데이터를 어떻게 반환받을 것인지 로직 구성 필요


final class PillAddMainViewController: UIViewController{
    
    private let sidePaddingSizeValue = 20
    private let componentsInset = 10
    private let cornerRadiusValue: CGFloat = 13
    
    private var titleForAdd = String()
    private var typeForAdd = String()
    private var dayForAdd = [String]()
    private var dueDateForAdd = String()
    private var intakeForAdd = [String]()
    private var dosageForAdd = String()
    private var alarmStatusForAdd = Bool()
    private var dosageUnitForAdd = String()
    
    private var alarmStatus: Bool = false
    private var timeData: String = ""
    private var dosage: String = ""
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 영양제 추가하기"
        label.font = FontLiteral.title3(style: .bold).withSize(20)
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark")?.withRenderingMode(.alwaysOriginal).withTintColor(.black), for: .normal)
        return button
    }()
    
    private let totalTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PillNameCell.self, forCellReuseIdentifier: PillNameCell.identifier)
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
    
    private lazy var navBackButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.totalTableView.dataSource = self
        self.totalTableView.delegate = self
        self.totalTableView.rowHeight = UITableView.automaticDimension
        
        backButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        
        navBackButton.tintColor = .black
        self.navigationItem.backBarButtonItem = navBackButton
        
        // 복용 알람 수정 삭제 옵저버 추가
        NotificationCenter.default.addObserver(self, selector: #selector(intakeModifyButtonTapped(_:)), name: .intakeModifyButtonTapped, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(intakeDeleteButtonTapped(_:)), name: .intakeDeleteButtonTapped, object: nil)
        
        setupView()
    }
    
    // 복용 알람 수정 삭제 옵저버 제거
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // 복용 알람 수정, 삭제 버튼 터치 시
    @objc private func intakeModifyButtonTapped(_ notification: Notification) {
        if let intake = notification.object as? String {
            print(#function + "진입")
            let intakeAddVC = IntakeAddViewController()
            intakeAddVC.delegate = self
            intakeAddVC.savedIntake = intake
            for i in 0..<self.intakeForAdd.count {
                if self.intakeForAdd[i] == intake { 
                    self.intakeForAdd.remove(at: i)
                    break
                }
            }
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.pushViewController(intakeAddVC, animated: true)
        }
    }
    
    
    @objc private func intakeDeleteButtonTapped(_ notification: Notification) {
        if let intake = notification.object as? String {
            let alert = UIAlertController(title: "알람 삭제", message: "해당 알람을 삭제하시겠습니까?", preferredStyle: .alert)
            let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
                for i in 0..<self.intakeForAdd.count {
                    if self.intakeForAdd[i] == intake {
                        self.intakeForAdd.remove(at: i)
                        break
                    }
                }
                self.totalTableView.reloadData()
            }
            let reject = UIAlertAction(title: "취소", style: .default)
            alert.addAction(delete)
            alert.addAction(reject)
            self.present(alert, animated: true)
        }
    }
    
    // 추가버튼 눌렀을 떄, 알럿 및 화면 빠져나오기 기능 구현
    @objc private func addButtonTapped() {
        
        if self.titleForAdd != "" 
            && self.typeForAdd != ""
            && self.dayForAdd != []
            && self.dueDateForAdd != ""
            && self.intakeForAdd != []
            && self.dosageForAdd != ""
            && self.dosageUnitForAdd != "" {
            let newPillData = Pill(title: self.titleForAdd,
                                   type: self.typeForAdd,
                                   day: self.dayForAdd,
                                   dueDate: self.dueDateForAdd,
                                   intake: self.intakeForAdd,
                                   dosage: self.dosageForAdd,
                                   dosageUnit: self.dosageUnitForAdd,
                                   alarmStatus: self.alarmStatusForAdd)
            
            DataManager.shared.createPillData(pill: newPillData)
            
            let addAlert = UIAlertController(title: "추가 완료", message: "약 추가가 정상적으로 완료되었습니다!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { _  in
                self.dismiss(animated: true)
            }
            addAlert.addAction(okAction)
            
            present(addAlert, animated: true)
        }
        let alert = UIAlertController(title: "저장할 수 없습니다.", message: "입력하지 않은 정보가 있는지 확인해주세요.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .destructive, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true)
        return
    }
    
    @objc func dismissView() {
        dismiss(animated: true)
    }
    
    //키보드 외부 터치 시 키보드 숨김처리
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 키보드 리턴 버튼 누를경우 키보드 숨김처리
    func textFieldShouldReturn(_ textField: UITextField) {
        if let pillCell = self.totalTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PillNameCell {
            pillCell.hideKeyboard()
        }
    }
    
    //뷰가 나타날 때 네비게이션 바 숨김
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.totalTableView.reloadData()
    }
    
    private func setupView() {
        addButtonView.addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.top.bottom.leading.trailing.centerX.centerY.equalToSuperview()
        }
        
        [backButton, titleLabel, totalTableView, addButtonView].forEach {
            view.addSubview($0)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(sidePaddingSizeValue)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(componentsInset)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(componentsInset)
            $0.centerX.equalToSuperview()
        }
        
        totalTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).inset(-sidePaddingSizeValue)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(addButtonView.snp.top).inset(-sidePaddingSizeValue)
        }
        
        addButtonView.snp.makeConstraints {
            $0.width.equalTo(339)
            $0.height.equalTo(53)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(componentsInset)
        }
    }
}

//MARK: - TableView DataSource, Delegate
extension PillAddMainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 각 인덱스에 따라 다른 커스텀 셀 반환
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PillCell", for: indexPath) as! PillNameCell
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

extension PillAddMainViewController: IntakeSettingDelegate {
    func addIntake() {
        let intakeAddVC = IntakeAddViewController()
        intakeAddVC.delegate = self
        intakeAddVC.savedIntakeList = intakeForAdd
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(intakeAddVC, animated: true)
    }
}

extension PillAddMainViewController: PillNameCellDelegate, AlarmCellDelegate,intakeNumberCellDelegate, IntakeDateCellDelegate, PillTypeCellDelegate ,DueDateCellDelegate, IntakeAddDelegate, IntakeAlarmDelegate {
    func modifyIntakeAlarm(intake: String) {
        print(#function + "진입")
        let intakeAddVC = IntakeAddViewController()
        intakeAddVC.delegate = self
        intakeAddVC.savedIntake = intake
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(intakeAddVC, animated: true)
    }
    
    func deleteIntakeAlarm(intake: String) {
        let alert = UIAlertController(title: "알람 삭제", message: "해당 알람을 삭제하시겠습니까?", preferredStyle: .alert)
        let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
            for i in 0..<self.intakeForAdd.count {
                if self.intakeForAdd[i] == intake { self.intakeForAdd.remove(at: i) }
            }
            self.totalTableView.reloadData()
        }
        let reject = UIAlertAction(title: "취소", style: .default)
        alert.addAction(delete)
        alert.addAction(reject)
        self.present(alert, animated: true)
    }
    
    func updateUnit(unit: String) {
        self.dosageUnitForAdd = unit
    }
    
    func updateAlarmStatus(status: Bool) {
        self.alarmStatusForAdd = status
    }
    
    func updateDataFromIntakeAddViewController(intake: String) {
        self.intakeForAdd.append(intake)
        self.intakeForAdd = self.intakeForAdd.sorted()
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
        self.intakeForAdd = self.intakeForAdd.sorted()
    }
    
    func updateDueDateCellHeight() {
        self.totalTableView.reloadData()
        self.totalTableView.scrollToRow(at: IndexPath(row: 6, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
    }
}

