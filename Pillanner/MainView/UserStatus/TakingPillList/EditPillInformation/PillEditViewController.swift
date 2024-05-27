//
//  PillAddMainViewController.swift
//  Pillanner
//
//  Created by 박민정 on 2/29/24.
//

import UIKit
import SnapKit
import SwiftUI

// 셀이 가지고 있는 약 정보 받아올 수 있도록 initializer setting 필요
// 데이터를 어떻게 반환받을 것인지 로직 구성 필요

final class PillEditViewController: UIViewController {
    
    private let sidePaddingSizeValue = 20
    private let cornerRadiusValue: CGFloat = 13
    
    private var titleForEdit = String()
    private var typeForEdit = String()
    private var dayForEdit = [String]()
    private var dueDateForEdit = String()
    private var intakeForEdit = [String]()
    private var dosageForEdit = String()
    private var dosageUnitForEdit = String()
    private var alarmStatusForEdit = Bool()
    
    private var oldPillDataForEdit: Pill
    private var originalPillTitle: String
    
    private var alarmStatus: Bool = false
    private var timeData: String = ""
    private var dosage: String = ""
    private var dosageUnit: String = ""
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 영양제 수정하기"
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
    
    private lazy var editButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.pointThemeColor2
        view.layer.cornerRadius = cornerRadiusValue
        return view
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.setTitle("수정하기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    private lazy var navigationBackButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    
    // 초기화 메서드를 추가합니다.
    // PillEditVC에 진입하는 시점의 title을 originalPillTitle에 저장해둡니다.
    init(pill: Pill) {
        self.oldPillDataForEdit = pill
        self.originalPillTitle = pill.title
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.totalTableView.dataSource = self
        self.totalTableView.delegate = self
        self.totalTableView.rowHeight = UITableView.automaticDimension
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        navigationBackButton.tintColor = .black
        self.navigationItem.backBarButtonItem = navigationBackButton
        
        setupView()
    }
    
    @objc func dismissView() {
        dismiss(animated: true)
    }
    
    // 저장버튼 눌렀을 때, 데이터 업데이트 및 알럿, 화면 빠져나오기 기능 추가
    @objc private func editButtonTapped() {
        
        if self.oldPillDataForEdit.title == "" {
            let alert = UIAlertController(title: "약의 이름을 확인해주세요.", message: "약의 이름은 공백일 수 없습니다. 다시 한 번 확인해주세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .destructive, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true)
        }
        // 빈 내용이 있으면 어떻게 처리할 지 고민해야 함
        
//        let newPill = Pill(title: self.titleForEdit, type: self.typeForEdit, day: self.dayForEdit, dueDate: self.dueDateForEdit, intake: self.intakeForEdit, dosage: self.dosageForEdit, dosageUnit: self.dosageUnitForEdit, alarmStatus: self.alarmStatusForEdit)
        
        DataManager.shared.updatePillData(oldTitle: originalPillTitle, pill: oldPillDataForEdit)
        
        DataManager.shared.readPillListData(UID: UserDefaults.standard.string(forKey: "UID")!) { pillList in
            if let pillList = pillList {
                print("########", pillList)
            }
        }
        
        let addAlert = UIAlertController(title: "수정 완료", message: "약 정보 수정이 정상적으로 완료되었습니다!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { _  in
//            self.navigationController?.popViewController(animated: true)
            self.dismissView()
        }
        addAlert.addAction(okAction)
        
        present(addAlert, animated: true)
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
    
    private func setupView() {
        editButtonView.addSubview(editButton)
        editButton.snp.makeConstraints {
            $0.top.bottom.leading.trailing.centerX.centerY.equalToSuperview()
        }
        [backButton, titleLabel, totalTableView, editButtonView].forEach {
            view.addSubview($0)
        }
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(sidePaddingSizeValue)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.centerX.equalToSuperview()
        }
        totalTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).inset(-sidePaddingSizeValue)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(editButtonView.snp.top).inset(-sidePaddingSizeValue)
        }
        editButtonView.snp.makeConstraints {
            $0.width.equalTo(339)
            $0.height.equalTo(53)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
}

extension PillEditViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 각 인덱스에 따라 다른 커스텀 셀 반환
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PillCell", for: indexPath) as! PillNameCell
            cell.setupLayoutOnEditingProcess(title: self.oldPillDataForEdit.title)
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as! AlarmCell
            cell.setupLayoutOnEditingProcess(alarmStatus: self.oldPillDataForEdit.alarmStatus)
            cell.delegate = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IntakeNumberCell", for: indexPath) as! IntakeNumberCell
            cell.setupLayoutOnEditingProcess(dosage: self.oldPillDataForEdit.dosage, unit: "정")
            cell.delegate = self
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IntakeDateCell", for: indexPath) as! IntakeDateCell
            cell.setupLayoutOnEditingProcess(days: self.oldPillDataForEdit.day)
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IntakeSettingCell", for: indexPath) as! IntakeSettingCell
            cell.setupLayoutOnEditingProcess(intake: self.oldPillDataForEdit.intake)
            cell.delegate = self
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PillTypeCell", for: indexPath) as! PillTypeCell
            cell.setupLayoutOnEditingProcess(type: self.oldPillDataForEdit.type)
            cell.delegate = self
            return cell
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeadlineCell", for: indexPath) as! DueDateCell
            cell.setupLayoutOnEditingProcess(dueDate: self.oldPillDataForEdit.dueDate)
            cell.delegate = self
            return cell
        default:
            fatalError("Invalid index path")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            let weekSelectVC = WeekdaySelectionViewController(selectedWeekdaysInString: oldPillDataForEdit.day)
            weekSelectVC.delegate = self
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.pushViewController(weekSelectVC, animated: true)
        }
    }
}

extension PillEditViewController: IntakeSettingDelegate {
    func addIntakeWithData() {
//        <#code#>
    }
    
    func addIntake() {
        let intakeAddVC = IntakeAddViewController()
        intakeAddVC.delegate = self
        intakeAddVC.savedIntakeList = self.intakeForEdit
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(intakeAddVC, animated: true)
//        let dosageNavVC = UINavigationController(rootViewController: dosageAddVC)
//        dosageNavVC.modalPresentationStyle = .fullScreen
//        self.present(dosageNavVC, animated: true)
    }
}

extension PillEditViewController:PillNameCellDelegate, AlarmCellDelegate,intakeNumberCellDelegate, IntakeDateCellDelegate, PillTypeCellDelegate ,DueDateCellDelegate, IntakeAddDelegate {
    func updateAlarmStatus(status: Bool) {
        self.alarmStatusForEdit = status
        self.oldPillDataForEdit.alarmStatus = status
    }
    
    func updateUnit(unit: String) {
        self.dosageUnitForEdit = unit
        self.oldPillDataForEdit.dosageUnit = unit
    }
    
    func updateDataFromIntakeAddViewController(intake: String) {
        print(#function)
        self.intakeForEdit.append(intake)
        self.oldPillDataForEdit.intake.append(intake)
        self.totalTableView.reloadData()
    }
    
    func updatePillTitle(_ title: String) {
        self.titleForEdit = title
        self.oldPillDataForEdit.title = title
    }
    
    func updatePillType(_ type: String) {
        self.typeForEdit = type
        self.oldPillDataForEdit.type = type
    }
    
    func updateDays(_ day: [String]) {
        self.dayForEdit = day
        self.oldPillDataForEdit.day = day
        self.totalTableView.reloadData()
    }
    
    func updateDueDate(date: String) {
        self.dueDateForEdit = date
        self.oldPillDataForEdit.dueDate = date
    }
    
    func updateDosage(dosage: String) {
        self.oldPillDataForEdit.dosage = dosage
        self.dosageForEdit = dosage
    }
    
    func updateIntake(_ intake: String) {
        self.intakeForEdit.append(intake)
    }
    
    
    func updateDueDateCellHeight() {
        self.totalTableView.reloadData()
        self.totalTableView.scrollToRow(at: IndexPath(row: 6, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
    }
}
