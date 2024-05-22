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
    
    var savedIntake: [String] = []
    
    private var timeSettingLabel: UILabel!
    private var selectedTimeLabel: UILabel!
    private var pickerContainerView: UIView!
    private var timePickerView: UIPickerView!
    private var confirmButton: UIButton!
    
    private var selectTimeButton: UIButton!
    private var selectedTimeDisplayLabel: UILabel!
    
    private var tempSelectedMeridiem: String?
    private var tempSelectedHour: String?
    private var tempSelectedMinute: String?
    
    
    let meridiem = ["오전", "오후"]
    let hours = Array(1...12).map { "\($0)" }
    let minutes = Array(0...59).map { String(format: "%02d", $0) }
    
    init(savedIntake: [String]) {
        self.savedIntake = savedIntake
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        self.navigationItem.title = "복용 알람 추가"
        let textAttributes = [NSAttributedString.Key.font: FontLiteral.title3(style: .bold)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    private func setupUI() {
        setupTimeSetting()
        setupPickerContainerView()
        setupTimeSettingTapGesture()
        setupConfirmButton()
        setupSaveButton()
        setupSelectTimeButton()
        setupSelectedTimeDisplayLabel()
    }
    
    
    private func setupSelectTimeButton() {
        selectTimeButton = UIButton(type: .system)
        selectTimeButton.setTitle("복용시간 선택", for: .normal)
        selectTimeButton.setTitleColor(.black, for: .normal)
        selectTimeButton.titleLabel?.font = FontLiteral.body(style: .regular)
        selectTimeButton.layer.borderWidth = 0
        selectTimeButton.layer.cornerRadius = 10
        selectTimeButton.backgroundColor = UIColor.pointThemeColor2
        selectTimeButton.addTarget(self, action: #selector(selectTimeButtonTapped), for: .touchUpInside)
        view.addSubview(selectTimeButton)
        
        selectTimeButton.snp.makeConstraints { make in
            make.centerY.equalTo(timeSettingLabel.snp.centerY)
            make.left.equalTo(timeSettingLabel.snp.right).offset(10)
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

            let timeString = "\(hour):\(minute), (\(meridiem) \(hourString):\(minute))"
            self.intake = timeString
            selectedTimeDisplayLabel.text = timeString
        }
        hidePickerView()
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
        
        print("저장 버튼이 탭되었습니다.")
        
        // 사용자 입력 데이터 처리
        let intakeData = self.intake
        
        // 추가하려는 알람의 시간이 중복되었을 때 알람을 추가할 수 없도록
        if savedIntake.contains(intakeData) {
            let duplicatedAlert: UIAlertController = {
                let alert = UIAlertController(title: "알람 시간 중복", message: "이미 해당 시간에 알람이 설정되어 있습니다!", preferredStyle: .alert)
                let editAction = UIAlertAction(title: "수정", style: .default)
                alert.addAction(editAction)
                return alert
            }()
            self.present(duplicatedAlert, animated: true)
        } else if intakeData == "" {
            let emptyAlert: UIAlertController = {
                let alert = UIAlertController(title: "시간 입력 필요", message: "알람을 드릴 시간을 알려주세요!", preferredStyle: .alert)
                let editAction = UIAlertAction(title: "확인", style: .default)
                alert.addAction(editAction)
                return alert
            }()
            self.present(emptyAlert, animated: true)
        } else {
            // delegate를 통해 데이터 전달 -> PillAdd 혹은 PillEditVC로 데이터 전달
            delegate?.updateDataFromIntakeAddViewController(intake: intakeData)
            // 현재 ViewController 닫기
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupTimeSetting() {
        timeSettingLabel = UILabel()
        timeSettingLabel.text = "약을 복용하실 시간을 설정하세요"
        timeSettingLabel.font = FontLiteral.body(style: .bold)
        view.addSubview(timeSettingLabel)
        
        selectedTimeLabel = UILabel()
        selectedTimeLabel.font = FontLiteral.title3(style: .bold)
        view.addSubview(selectedTimeLabel)
        
        timeSettingLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.width.equalTo(200)
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


