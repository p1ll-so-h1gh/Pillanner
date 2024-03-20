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
protocol DosageAddDelegate: AnyObject {
    func updateDataFromDosageAddViewController(alarmStatus: Bool, intake: String, dosage: String, unit: String)
    
}


class DosageAddViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    weak var delegate: DosageAddDelegate?
    
    // 유저 입력을 저장할 변수
    var alarmStatus: Bool = false
    var intake: String = ""
    var dosage: String = ""
    var dosageUnit: String = ""
    
    private var pageTitleLabel: UILabel!
    private var alarmSettingLabel: UILabel!
    private var alarmToggle: UISwitch!
    private var timeSettingLabel: UILabel!
    private var dosageCountLabel: UILabel!
    private var selectedTimeLabel: UILabel!
    private var pickerContainerView: UIView!
    private var timePickerView: UIPickerView!
    private var confirmButton: UIButton!
    
    private var selectTimeButton: UIButton!
    private var selectedTimeDisplayLabel: UILabel!
    
    private var alarmStatusLabel: UILabel!
    
    private var tempSelectedMeridiem: String?
    private var tempSelectedHour: String?
    private var tempSelectedMinute: String?
    
    private var dosageInputTextField: UITextField!
    private var dosageConfirmButton: UIButton!
    
    private var dosageInputContainer: UIView!
    
    
    let meridiem = ["오전", "오후"]
    let hours = Array(1...12).map { "\($0)" }
    let minutes = Array(0...59).map { String(format: "%02d", $0) }
    
    
    //mark-test dropdown
    private var dosageUnitSelectionButton: UIButton!
    private var dosageUnitTableView: UITableView!
    private let dosageUnits = ["캡슐", "정", "개", "포", "병", "g", "ml"]
    private var isDropdownVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        self.navigationItem.title = "복용횟수추가"
        let textAttributes = [NSAttributedString.Key.font: FontLiteral.title3(style: .bold)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    private func setupUI() {
        setupAlarmSetting()
        setupTimeSetting()
        setupDosageCount()
        setupPickerContainerView()
        setupTimeSettingTapGesture()
        setupConfirmButton()
        setupDosageInputContainer()
        setupSaveButton()
        setupAlarmStatusLabel()
        setupDosageUnitSelectionButton()
        setupDosageUnitTableView()
        
        setupSelectTimeButton()
        setupSelectedTimeDisplayLabel()
    }
    
    
    private func setupSelectTimeButton() {
        selectTimeButton = UIButton(type: .system)
        selectTimeButton.setTitle("섭취시간 선택", for: .normal)
        selectTimeButton.setTitleColor(.white, for: .normal)
        selectTimeButton.titleLabel?.font = FontLiteral.body(style: .bold)
        selectTimeButton.layer.borderWidth = 0
        selectTimeButton.layer.cornerRadius = 10
        selectTimeButton.backgroundColor = UIColor.pointThemeColor2
        selectTimeButton.addTarget(self, action: #selector(selectTimeButtonTapped), for: .touchUpInside)
        view.addSubview(selectTimeButton)
        
        selectTimeButton.snp.makeConstraints { make in
            make.centerY.equalTo(timeSettingLabel.snp.centerY)
            make.left.equalTo(timeSettingLabel.snp.right).offset(30)
            make.right.equalToSuperview().inset(20)
            
            make.height.equalTo(40)
        }
    }
    
    private func setupSelectedTimeDisplayLabel() {
        selectedTimeDisplayLabel = UILabel()
        selectedTimeDisplayLabel.font = FontLiteral.title3(style: .bold)
        view.addSubview(selectedTimeDisplayLabel)
        
        selectedTimeDisplayLabel.snp.makeConstraints { make in
            make.top.equalTo(timeSettingLabel.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(30)
        }
    }
    
    
    @objc private func alarmToggleChanged(_ toggle: UISwitch) {
        updateAlarmStatusLabel(isOn: toggle.isOn)
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

            let timeString = String(format: "%02d:%@", hour, minute)
            self.intake = timeString
            selectedTimeDisplayLabel.text = timeString
        }
        hidePickerView()
    }
    
    
    private func setupDosageUnitSelectionButton() {
        dosageUnitSelectionButton = UIButton(type: .system)
        dosageUnitSelectionButton.setTitle("단위 선택", for: .normal)
        dosageUnitSelectionButton.setTitleColor(.white, for: .normal)
        dosageUnitSelectionButton.titleLabel?.font = FontLiteral.body(style: .bold)
        dosageUnitSelectionButton.layer.borderWidth = 0
        dosageUnitSelectionButton.layer.cornerRadius = 10
        dosageUnitSelectionButton.backgroundColor = UIColor.pointThemeColor2
        
        
        dosageUnitSelectionButton.addTarget(self, action: #selector(toggleDropdown), for: .touchUpInside)
        view.addSubview(dosageUnitSelectionButton)
        
        dosageUnitSelectionButton.snp.makeConstraints { make in
            make.top.equalTo(dosageInputContainer.snp.top)
            make.left.equalTo(dosageInputContainer.snp.right).offset(20)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(dosageInputContainer.snp.height)
        }
    }
    
    private func setupDosageUnitTableView() {
        dosageUnitTableView = UITableView()
        dosageUnitTableView.delegate = self
        dosageUnitTableView.dataSource = self
        dosageUnitTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        dosageUnitTableView.isHidden = true
        view.addSubview(dosageUnitTableView)
        
        dosageUnitTableView.snp.makeConstraints { make in
            make.top.equalTo(dosageUnitSelectionButton.snp.bottom)
            make.left.right.equalTo(dosageUnitSelectionButton)
            make.height.equalTo(200)
        }
    }
    
    @objc private func toggleDropdown() {
        isDropdownVisible.toggle()
        dosageUnitTableView.isHidden = !isDropdownVisible
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dosageUnits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dosageUnits[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dosageUnitSelectionButton.setTitle(dosageUnits[indexPath.row], for: .normal)
        self.dosageUnit = dosageUnits[indexPath.row]
        toggleDropdown()
    }
    
    
    @objc private func dosageInputContainerTapped() {
        dosageInputTextField.becomeFirstResponder()
    }
    
    // 저장버튼 셋업
    private func setupSaveButton() {
        let saveButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
        saveButtonItem.setTitleTextAttributes([NSAttributedString.Key.font: FontLiteral.title3(style: .bold)], for: .normal)
        saveButtonItem.tintColor = UIColor.pointThemeColor
        self.navigationItem.rightBarButtonItem = saveButtonItem
    }
    
    // 저장버튼 누르면 동작하는 거
    @objc private func saveButtonTapped() {
        
//        delegate?.cellHeightChanged()
        
        print("저장 버튼이 탭되었습니다.")

        // 사용자 입력 데이터 처리
        let isAlarmOn = self.alarmToggle.isOn
        let intakeData = self.intake // 시간 데이터는 사용자가 시간을 선택할 때 저장되어 있어야 합니다.
        let dosage = self.dosageInputTextField.text ?? ""
        let unit = self.dosageUnitSelectionButton.title(for: .normal) ?? ""
        
        // delegate를 통해 데이터 전달 -> PillAdd 혹은 PillEditVC로 데이터 전달
        delegate?.updateDataFromDosageAddViewController(alarmStatus: isAlarmOn,
                                                        intake: intakeData,
                                                        dosage: dosage,
                                                        unit: unit)
        // 현재 ViewController 닫기
        navigationController?.popViewController(animated: true)
    }
    
    
    private func setupAlarmSetting() {
        alarmSettingLabel = UILabel()
        alarmSettingLabel.text = "알람설정"
        alarmSettingLabel.font = FontLiteral.body(style: .bold)
        view.addSubview(alarmSettingLabel)
        
        alarmToggle = UISwitch()
        alarmToggle.onTintColor = UIColor.pointThemeColor2
        view.addSubview(alarmToggle)
        
        alarmToggle.addTarget(self, action: #selector(alarmToggleChanged), for: .valueChanged)
        
        // 네비게이션 바 아래 40포인트 위치 조정
        alarmSettingLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(40)
            make.left.equalToSuperview().offset(20)
        }
        
        alarmToggle.snp.makeConstraints { make in
            make.centerY.equalTo(alarmSettingLabel.snp.centerY)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    
    
    private func setupAlarmStatusLabel() {
        alarmStatusLabel = UILabel()
        alarmStatusLabel.font = FontLiteral.body(style: .bold)
        alarmStatusLabel.textColor = UIColor.pointThemeColor
        view.addSubview(alarmStatusLabel)
        
        alarmStatusLabel.snp.makeConstraints { make in
            make.centerY.equalTo(alarmToggle.snp.centerY)
            make.left.equalTo(alarmSettingLabel.snp.right).offset(10)
        }
        updateAlarmStatusLabel(isOn: alarmToggle.isOn)
    }
    
    
    
    private func updateAlarmStatusLabel(isOn: Bool) {
        alarmStatusLabel.text = isOn ? "on" : "off"
    }
    
    private func setupTimeSetting() {
        timeSettingLabel = UILabel()
        timeSettingLabel.text = "섭취 시간을 설정하세요"
        timeSettingLabel.font = FontLiteral.body(style: .bold)
        view.addSubview(timeSettingLabel)
        
        selectedTimeLabel = UILabel()
        selectedTimeLabel.font = FontLiteral.title3(style: .bold)
        view.addSubview(selectedTimeLabel)
        
        timeSettingLabel.snp.makeConstraints { make in
            make.top.equalTo(alarmSettingLabel.snp.bottom).offset(60)
            make.left.equalToSuperview().offset(20)
        }
        
        selectedTimeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(timeSettingLabel.snp.centerY)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    private func setupPickerContainerView() {
        pickerContainerView = UIView()
        view.addSubview(pickerContainerView)
        pickerContainerView.layer.borderWidth = 1.0
        pickerContainerView.layer.borderColor = UIColor.tertiaryLabel.cgColor
        pickerContainerView.layer.cornerRadius = 20
        pickerContainerView.backgroundColor = .white
        pickerContainerView.isHidden = true
        
        pickerContainerView.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(20)
            make.height.equalTo(260)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-100)
        }
        
        setupTimePickerView()
    }
    
    private func setupConfirmButton() {
        confirmButton = UIButton(type: .system)
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3).withTraits(.traitBold)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.backgroundColor = UIColor.pointThemeColor2
        confirmButton.layer.cornerRadius = 20
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        view.addSubview(confirmButton) // 뷰에 confirmButton 추가
        pickerContainerView.addSubview(confirmButton)
        
        confirmButton.snp.makeConstraints { make in
            make.left.right.equalTo(view).inset(20)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }
        
        view.bringSubviewToFront(confirmButton)
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
        pickerContainerView.isHidden = false
        confirmButton.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.pickerContainerView.snp.updateConstraints { make in
                make.height.equalTo(260)
                make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func hidePickerView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.pickerContainerView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            self.view.layoutIfNeeded()
        }) { _ in
            self.pickerContainerView.isHidden = true
            self.confirmButton.isHidden = true
        }
    }
    
    
    private func setupDosageCount() {
        dosageCountLabel = UILabel()
        dosageCountLabel.text = "1회 기준 섭취 개수를 선택하세요"
        dosageCountLabel.font = FontLiteral.body(style: .bold)
        view.addSubview(dosageCountLabel)
        
        dosageCountLabel.snp.makeConstraints { make in
            make.top.equalTo(timeSettingLabel.snp.bottom).offset(90)
            make.left.equalToSuperview().offset(20)
        }
        
        
    }
    
    private func setupDosageInputContainer() {
        dosageInputContainer = UIView()
        dosageInputContainer.layer.borderWidth = 1.0
        dosageInputContainer.layer.borderColor = UIColor.tertiaryLabel.cgColor
        dosageInputContainer.layer.cornerRadius = 10
        dosageInputContainer.backgroundColor = .white
        view.addSubview(dosageInputContainer)
        
        dosageInputContainer.snp.makeConstraints { make in
            make.top.equalTo(dosageCountLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(20)
            make.right.equalTo(view.snp.centerX).offset(-10) // 가로 크기 절반으로 조정
            make.height.equalTo(40)
        }
        dosageInputTextField = UITextField()
        dosageInputTextField.delegate = self
        dosageInputTextField.keyboardType = .numberPad
        dosageInputTextField.placeholder = "복용량 개수 입력"
        dosageInputTextField.textAlignment = .center
        dosageInputContainer.addSubview(dosageInputTextField)
        
        dosageInputTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    private func setupTimePickerView() {
        timePickerView = UIPickerView()
        pickerContainerView.addSubview(timePickerView)
        timePickerView.delegate = self
        timePickerView.dataSource = self
        
        timePickerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    private func setupTimeSettingTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectTimeButtonTapped))
        timeSettingLabel.isUserInteractionEnabled = true
        timeSettingLabel.addGestureRecognizer(tapGesture)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
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
    
    
    
    private func setupDosageInputField() {
        dosageInputTextField = UITextField()
        dosageInputTextField.keyboardType = .numberPad
        dosageInputTextField.placeholder = "개수 입력"
        dosageInputTextField.borderStyle = .roundedRect
        dosageInputTextField.textAlignment = .right
        view.addSubview(dosageInputTextField)
        
        dosageInputTextField.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.centerY.equalTo(dosageCountLabel.snp.centerY)
            make.width.equalTo(100)
        }
        
        dosageConfirmButton = UIButton(type: .system)
        dosageConfirmButton.setTitle("확인", for: .normal)
        dosageConfirmButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3).withTraits(.traitBold)
        dosageConfirmButton.setTitleColor(.white, for: .normal)
        dosageConfirmButton.backgroundColor = UIColor.pointThemeColor
        dosageConfirmButton.layer.cornerRadius = 10
        
        view.addSubview(dosageConfirmButton)
        
        dosageConfirmButton.snp.makeConstraints { make in
            make.top.equalTo(dosageInputTextField.snp.bottom).offset(20)
            make.centerX.equalTo(dosageInputTextField.snp.centerX)
            make.width.equalTo(dosageInputTextField.snp.width)
            make.height.equalTo(50)
        }
        
        dosageInputTextField.isHidden = true
        dosageConfirmButton.isHidden = true
    }
    
    private func setupDosageCountTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dosageCountLabelTapped))
        dosageCountLabel.isUserInteractionEnabled = true
        dosageCountLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dosageCountLabelTapped() {
        dosageInputTextField.isHidden = false
        dosageConfirmButton.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.dosageInputTextField.alpha = 1.0
            self.dosageConfirmButton.alpha = 1.0
        }
        dosageInputTextField.becomeFirstResponder()
    }
}

extension DosageAddViewController {
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


