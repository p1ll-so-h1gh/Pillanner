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
    private var dosageForEdit = Double()
    
    private var oldPillDataForEdit: Pill
    private let originalPillTitle: String

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
        tableView.register(PillCell.self, forCellReuseIdentifier: PillCell.identifier)
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
    
    private lazy var navBackButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    
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
        self.totalTableView.rowHeight = UITableView.automaticDimension
        
        backButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        navBackButton.tintColor = .black
        self.navigationItem.backBarButtonItem = navBackButton
        
        setupView()
    }
    
    @objc func dismissView() {
        dismiss(animated: true)
    }
    
    @objc private func editButtonTapped() {
        // 각 셀들의 상태를 어떻게 업데이트 받을지...
        
        DataManager.shared.updatePillData(oldTitle: originalPillTitle, newTitle: self.titleForEdit, type: self.typeForEdit, day: self.dayForEdit, dueDate: self.dueDateForEdit, intake: self.intakeForEdit, dosage: self.dosageForEdit)
        
        DataManager.shared.readPillListData(UID: UserDefaults.standard.string(forKey: "UID")!) { pillList in
            print(pillList)
        }
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

extension PillEditViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 각 인덱스에 따라 다른 커스텀 셀 반환
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PillCell", for: indexPath) as! PillCell
            cell.setupLayoutOnEditingProcess(title: self.oldPillDataForEdit.title)
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IntakeDateCell", for: indexPath) as! IntakeDateCell
            cell.setupLayoutOnEditingProcess(days: self.oldPillDataForEdit.day)
//            cell.delegate = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IntakeSettingCell", for: indexPath) as! IntakeSettingCell
            cell.setupLayoutOnEditingProcess(numberOfIntake: self.oldPillDataForEdit.intake.count)
            cell.delegate = self
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PillTypeCell", for: indexPath) as! PillTypeCell
            cell.setupLayoutOnEditingProcess(type: self.oldPillDataForEdit.type)
//            cell.delegate = self
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeadlineCell", for: indexPath) as! DueDateCell
            cell.setupLayoutOnEditingProcess(dueDate: self.oldPillDataForEdit.dueDate)
            cell.delegate = self
            return cell
        default:
            fatalError("Invalid index path")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let weekSelectVC = WeekdaySelectionViewController()
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.pushViewController(weekSelectVC, animated: true)
        }
    }
}

extension PillEditViewController: IntakeSettingDelegate {
    func addDosage() {
        let dosageAddVC = DosageAddViewController()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(dosageAddVC, animated: true)
    }
}

extension PillEditViewController: PillCellDelegate, IntakeDateCellDelegate, PillTypeCellDelegate ,DueDateCellDelegate, DosageAddDelegate {
    
    func updatePillTitle(_ title: String) {
        self.titleForEdit = title
    }
    
    func updatePillType(_ type: String) {
        self.typeForEdit = type
    }
    
    func updateDays(_ day: [String]) {
        self.dayForEdit = day
    }
    
    func updateDueDate(date: String) {
        self.dueDateForEdit = date
    }
    
    func updateDosage(_ dosage: Double) {
        self.dosageForEdit = dosage
    }
    
    func updateIntake(_ intake: String) {
        self.intakeForEdit.append(intake)
    }
    
    
    func updateCellHeight() {
        self.totalTableView.reloadData()
        self.totalTableView.scrollToRow(at: IndexPath(row: 4, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
    }
}
