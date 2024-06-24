//
//  DosageAddViewController.swift
//  Pillanner
//
//  Created by 김가빈 on 3/4/24.
//

import UIKit
import SnapKit

// 약 정보 수정하는 뷰에서 접근할 때, 약 정보 받아올 수 있는 방법 필요

// DosageAddDelegate 프로토콜 수정
protocol IntakeAddDelegate: AnyObject {
    func updateDataFromIntakeAddViewController(intake: String)
}


class IntakeAddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    weak var delegate: IntakeAddDelegate?
    
    // 유저 입력을 저장할 변수
    var intake: String = ""
    
    // 알람 시간 중복을 체크하기 위해서, pillAdd/EditVC에서 받아올 데이터
    var savedIntakeList: [String]?
    // 알람 시간 수정을 위해 받을 데이터
    var savedIntake: String?
    // IntakeAddViewController에 수정으로 접근했는지 분별하기 위한 플래그 -> 이거 해서 뭐할건데?? 구체화해야됨
    var modifyFlag = false
    
    private var suggestionLabel: UILabel = {
        let label = UILabel()
        label.text = "약을 복용하실 시간을 설정하세요."
        label.font = FontLiteral.body(style: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private var timePickerView = UIPickerView()
    
    private var selectedTimeLabel: UILabel = {
        var label = UILabel()
        label.text = ""
        label.font = FontLiteral.title3(style: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3).withTraits(.traitBold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.pointThemeColor2
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var timeSelectionButton: UIButton = {
        var button = UIButton()
        button = UIButton(type: .system)
        button.setTitle("복용시간 선택", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = FontLiteral.body(style: .regular)
        button.layer.borderWidth = 0
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.pointThemeColor2
        button.addTarget(self, action: #selector(selectTimeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var tempSelectedMeridiem: String?
    private var tempSelectedHour: String?
    private var tempSelectedMinute: String?
    
    let meridiem = ["오전", "오후"]
    let hours = Array(1...12).map { "\($0)" }
    let minutes = Array(0...59).map { String(format: "%02d", $0) }

    // MARK: Life Cycle
    override func viewDidLoad() {
        timePickerView.delegate = self
        timePickerView.dataSource = self
        
        if let intakeData = savedIntake {
            self.intake = intakeData
            self.modifyFlag = true
            self.selectedTimeLabel.text = intakeData
            print("######", intakeData, modifyFlag)
        }
        if let intakeListData = savedIntakeList {
            self.savedIntakeList = intakeListData
            print("######", intakeListData)
        }
        
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
    }
    
    private func setupViews() {
        let buttonAndLabelSize = self.view.frame.height * 0.05
        let insetValue = self.view.frame.height * 0.02
        
        
        self.navigationItem.title = "복용 알람 추가"
        let textAttributes = [NSAttributedString.Key.font: FontLiteral.title3(style: .bold)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        setupSaveButton()
        setupBackButton()
        view.addSubview(suggestionLabel)
        view.addSubview(timeSelectionButton)
        view.addSubview(selectedTimeLabel)
        view.addSubview(timePickerView)
        view.addSubview(confirmButton)
        
        suggestionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(self.view.frame.height * 0.02)
            make.width.equalTo(self.view.frame.width * 0.8)
            make.left.right.equalToSuperview().inset(insetValue)
            make.height.equalTo(buttonAndLabelSize)
        }
        timeSelectionButton.snp.makeConstraints { make in
            make.top.equalTo(suggestionLabel.snp.bottom).offset(insetValue)
            make.left.right.equalToSuperview().inset(insetValue)
            make.height.equalTo(self.view.frame.height * 0.05)
            make.width.equalTo(self.view.frame.width * 0.7)
        }
        selectedTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(timeSelectionButton.snp.bottom).offset(insetValue)
            make.width.equalTo(self.view.frame.width * 0.8)
            make.height.equalTo(buttonAndLabelSize)
            make.left.right.equalToSuperview().inset(insetValue)
        }
        timePickerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(selectedTimeLabel.snp.bottom).offset(self.view.frame.height * 0.3)
            $0.height.equalTo(self.view.frame.height * 0.35)
            $0.width.equalTo(self.view.frame.width * 0.8)
        }
        confirmButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(timePickerView.snp.bottom).offset(insetValue)
            $0.height.equalTo(buttonAndLabelSize)
            $0.width.equalTo(self.view.frame.width * 0.8)
            $0.bottom.equalToSuperview().offset(-insetValue)
        }
        timePickerView.isHidden = true
        confirmButton.isHidden = true
    }
    
    private func setupSaveButton() {
        let saveButtonItem = UIBarButtonItem(
            title: "저장",
            style: .plain,
            target: self,
            action: #selector(saveButtonTapped)
        )
        saveButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: FontLiteral.title3(style: .bold)],
                                              for: .normal)
        saveButtonItem.tintColor = UIColor.pointThemeColor
        self.navigationItem.rightBarButtonItem = saveButtonItem
    }
    
    private func setupBackButton() {
        let backButton = UIBarButtonItem(
            image: UIImage(named: "backBtn"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backButtonTapped() {
        print(#function)
        if modifyFlag {
            print(#function, modifyFlag)
            if let savedIntake = self.savedIntake {
                delegate?.updateDataFromIntakeAddViewController(intake: savedIntake)
                navigationController?.popViewController(animated: true)
            }
        } else {
            print(#function, modifyFlag)
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func selectTimeButtonTapped() {
        if let meridiemIndex = meridiem.firstIndex(of: tempSelectedMeridiem ?? ""),
           let hourIndex = hours.firstIndex(of: tempSelectedHour ?? ""),
           let minuteIndex = minutes.firstIndex(of: tempSelectedMinute ?? "") {
            timePickerView.selectRow(meridiemIndex, inComponent: 0, animated: false)
            timePickerView.selectRow(hourIndex, inComponent: 1, animated: false)
            timePickerView.selectRow(minuteIndex, inComponent: 2, animated: false)
        }
        showPickerView()
    }
    
    private func showPickerView() {
        let buttonAndLabelSize = self.view.frame.height * 0.075
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }) { _ in
            self.timePickerView.isHidden = false
            self.confirmButton.isHidden = false
        }
    }
    
    private func hidePickerView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        }) { _ in
            self.timePickerView.isHidden = true
            self.confirmButton.isHidden = true
        }
    }
    
    @objc private func confirmButtonTapped() {
        if let meridiem = tempSelectedMeridiem,
           let hourString = tempSelectedHour,
           let minute = tempSelectedMinute {
            
            var hour = Int(hourString) ?? 0
            
            if meridiem == "오후" && hour != 12 {
                hour = (hour % 12) + 12
            } else if meridiem == "오전" && hour == 12 {
                hour = 0
            }

            let timeString = "\(hour):\(minute)"
            self.intake = timeString
            selectedTimeLabel.text = timeString
        }
        selectedTimeLabel.isHidden = false
        print("self.intake = \(self.intake)")
        hidePickerView()
    }
    
    @objc private func saveButtonTapped() {
        
        print("저장 버튼이 탭되었습니다.")
        
        // 사용자 입력 데이터 처리
        let intakeData = self.intake
        print(intakeData)
        
        // 추가하려는 알람의 시간이 중복되었을 때 알람을 추가할 수 없도록
        if let data = savedIntakeList {
            print("cond 1")
            if data.contains(intakeData) {
                let duplicatedAlert: UIAlertController = {
                    let alert = UIAlertController(title: "알람 시간 중복", message: "이미 해당 시간에 알람이 설정되어 있습니다!", preferredStyle: .alert)
                    let editAction = UIAlertAction(title: "수정", style: .default)
                    alert.addAction(editAction)
                    return alert
                }()
                self.present(duplicatedAlert, animated: true)
            } else if intakeData == "" {
                print("cond 2")
                let emptyAlert: UIAlertController = {
                    let alert = UIAlertController(title: "시간 입력 필요", message: "알람을 드릴 시간을 알려주세요!", preferredStyle: .alert)
                    let editAction = UIAlertAction(title: "확인", style: .default)
                    alert.addAction(editAction)
                    return alert
                }()
                self.present(emptyAlert, animated: true)
            } else {
                print("cond 3")
                // delegate를 통해 데이터 전달 -> PillAddVC 혹은 PillEditVC로 데이터 전달
                delegate?.updateDataFromIntakeAddViewController(intake: intakeData)
                // 현재 ViewController 닫기
                navigationController?.popViewController(animated: true)
            }
        } else {
            print("cond 4")
            // delegate를 통해 데이터 전달 -> PillAddVC 혹은 PillEditVC로 데이터 전달
            delegate?.updateDataFromIntakeAddViewController(intake: intakeData)
            // 현재 ViewController 닫기
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc(numberOfComponentsInPickerView:) func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    @objc func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return meridiem.count
        case 1:
            return hours.count
        case 2:
            return minutes.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return meridiem[row]
        case 1:
            return hours[row]
        case 2:
            return minutes[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let meridiemIndex = pickerView.selectedRow(inComponent: 0)
        let hourIndex = pickerView.selectedRow(inComponent: 1)
        let minuteIndex = pickerView.selectedRow(inComponent: 2)
        
        if meridiemIndex < meridiem.count,
           hourIndex < hours.count,
           minuteIndex < minutes.count {
            tempSelectedMeridiem = meridiem[meridiemIndex]
            // 시간을 "hh" 포맷으로 변경하면서, 인덱스에 1을 더해 실제 시간 값으로 변환
            tempSelectedHour = String(format: "%02d", hourIndex + 1)
            tempSelectedMinute = minutes[minuteIndex]
        }
    }
}

extension IntakeAddViewController {
    // 키보드 외부 터치할 경우 키보드 숨김처리
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // 키보드 리턴 버튼 누를경우 키보드 숨김처리
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


