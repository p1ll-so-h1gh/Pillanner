
//  InitialSetUpViewController.swift
//  Pillanner
//
//  Created by 영현 on 2/22/24.

import UIKit
import SnapKit

class InitialSetupViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var questionLabel: UILabel!
    private var medicationReminderLabel: UILabel!
    private var pickerContainerView: UIView!
    private var timePickerView: UIPickerView!
    private var progressView: UIProgressView!
    private var intervalLabel: UILabel!
    private var selectedCountLabel: UILabel!
    private var selectedPillCount: Int?
    private var alarmIntervalDescriptionLabel: UILabel!
    private var selectedAlarmIntervalLabel: UILabel!
    
    
    private var selectedIntervalLabel: UILabel!
    private var selectedPillCountLabel: UILabel!

    
    // "확인" 버튼 추가
    private var confirmButton: UIButton!

    // 선택 정보 저장을 위한 변수
    private var selectedTimeForQuestion1: (hour: Int, minute: Int, meridiem: String)?
    private var selectedIntervalForQuestion2: Int?
    private var selectedPillCountForQuestion3: Int?

    private var tempSelectedTime: (hour: Int, minute: Int, meridiem: String)?
    private var tempSelectedInterval: Int?
    private var tempSelectedPillCount: Int?

    
    private var nextButton: UIButton!
    private var previousButton: UIButton!
    
    // 질문 1 식사시간 라벨
    private var breakfastTimeLabel: UILabel!
    private var lunchTimeLabel: UILabel!
    private var dinnerTimeLabel: UILabel!
    
    private var selectedBreakfastTimeLabel: UILabel!
    private var selectedLunchTimeLabel: UILabel!
    private var selectedDinnerTimeLabel: UILabel!
    
    private var currentSelectedMealType: MealType?
    
    enum MealType {
        case breakfast, lunch, dinner
    }
    
    let meridiem: [String] = ["오전", "오후"]
    let hours: [Int] = Array(1...12)
    let minutes: [Int] = Array(0...59)
    let intervalMinutes: [Int] = Array(stride(from: 5, through: 30, by: 5))
    let pillCounts: [Int] = Array(1...30)
    
    var currentQuestion = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI(for: currentQuestion)
        setupGestureRecognizers()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        
        setupProgressView()
        setupLabels()
        setupPickerContainerView()
        setupNavigationButtons()
        setupMealTimeLabels()
        setupSelectedCountLabel()
        setupIntervalLabel()
        setupSelectedIntervalLabel()
        setupSelectedPillCountLabel()
        setupConfirmButton()
        setupGestureRecognizers()
        
        // 모든 UI 컴포넌트가 설정된 후 UI를 업데이트
        updateUI(for: currentQuestion)
    }

    func setupIntervalLabel() {
        intervalLabel = UILabel()
        intervalLabel.textAlignment = .center
        intervalLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        intervalLabel.isHidden = true
        view.addSubview(intervalLabel)
        
        intervalLabel.snp.makeConstraints { make in
            make.top.equalTo(timePickerView.snp.bottom).offset(20)
            make.centerX.equalTo(view)
            make.height.equalTo(50)
        }
    }

    func setupSelectedIntervalLabel() {
        selectedIntervalLabel = UILabel()
        selectedIntervalLabel.textAlignment = .center
        selectedIntervalLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        view.addSubview(selectedIntervalLabel)
        
        selectedIntervalLabel.snp.makeConstraints { make in
            make.top.equalTo(medicationReminderLabel.snp.bottom).offset(80)
            make.centerX.equalToSuperview()
        }
    }

    func setupSelectedPillCountLabel() {
        selectedPillCountLabel = UILabel()
        selectedPillCountLabel.textAlignment = .center
        selectedPillCountLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        view.addSubview(selectedPillCountLabel)
        
        selectedPillCountLabel.snp.makeConstraints { make in
            make.top.equalTo(medicationReminderLabel.snp.bottom).offset(80)
            make.centerX.equalToSuperview()
        }
    }

    
    func setupConfirmButton() {
        confirmButton = UIButton(type: .system)
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.titleLabel?.font = FontLiteral.title3(style: .bold) // 폰트 설정
        confirmButton.setTitleColor(UIColor.pointThemeColor, for: .normal) // 텍스트 컬러 설정
        confirmButton.backgroundColor = .white // 배경색 설정
        confirmButton.layer.borderWidth = 1.0 // 테두리 두께 설정
        confirmButton.layer.borderColor = UIColor.pointThemeColor.cgColor // 테두리 색상 설정
        confirmButton.layer.cornerRadius = 20 // 모서리 둥글기 설정
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        
        view.addSubview(confirmButton)
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(pickerContainerView.snp.bottom).offset(2) // 피커뷰 2포인트 아래
            make.left.right.equalTo(pickerContainerView) // 너비는 피커뷰와 동일하게
            make.height.equalTo(50) // 높이 설정
        }
    }
    
    
    
    func setupGestureRecognizers() {
        // intervalLabel 및 selectedCountLabel에 대한 제스처 인식기 설정
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap))
        intervalLabel.addGestureRecognizer(tapGesture)
        intervalLabel.isUserInteractionEnabled = true
        
        let countLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLabelTap))
        selectedCountLabel.addGestureRecognizer(countLabelTapGesture)
        selectedCountLabel.isUserInteractionEnabled = true
    }

        

    @objc func handleLabelTap(_ sender: UITapGestureRecognizer) {
        showPickerView()
    }
    
    @objc func confirmButtonTapped() {
        switch currentQuestion {
        case 1:
            if let selectedTime = tempSelectedTime {
                // 최종 선택된 시간을 저장
                selectedTimeForQuestion1 = selectedTime
                
                // 선택된 시간을 UI에 표시
                let timeText = "\(selectedTime.meridiem) \(selectedTime.hour)시 \(selectedTime.minute)분"
                switch currentSelectedMealType {
                case .breakfast:
                    selectedBreakfastTimeLabel.text = timeText
                case .lunch:
                    selectedLunchTimeLabel.text = timeText
                case .dinner:
                    selectedDinnerTimeLabel.text = timeText
                default: break
                }
            }
        case 2:
            if let selectedInterval = tempSelectedInterval {
                // 최종 선택된 간격을 저장
                selectedIntervalForQuestion2 = selectedInterval
                // 선택된 간격을 UI에 표시
                selectedIntervalLabel.text = "\(selectedInterval)분"
            }
        case 3:
            if let selectedCount = tempSelectedPillCount {
                // 최종 선택된 알약 개수를 저장
                selectedPillCountForQuestion3 = selectedCount
                // 선택된 알약 개수를 UI에 표시
                selectedPillCountLabel.text = "\(selectedCount)개"
            }
        default: break
        }
        hidePickerView() // 선택을 확정한 후 피커뷰를 숨깁니다.
        checkIfSelectionsAreComplete() // 모든 선택이 완료되었는지 확인하고 다음 버튼을 활성화합니다.
    }
    
    
    func checkIfSelectionsAreComplete() {
        switch currentQuestion {
        case 1:
            // 모든 식사 시간이 선택되었는지 확인
            let allTimesSelected = selectedBreakfastTimeLabel.text != nil && selectedLunchTimeLabel.text != nil && selectedDinnerTimeLabel.text != nil
            nextButton.isEnabled = allTimesSelected
            nextButton.setImage(allTimesSelected ? UIImage(named: "nextButtonSelectedImage") : UIImage(named: "nextButtonImage"), for: .normal)
        case 2:
            // 간격이 선택되었는지 확인
            let intervalSelected = selectedIntervalForQuestion2 != nil
            nextButton.isEnabled = intervalSelected
            nextButton.setImage(intervalSelected ? UIImage(named: "nextButtonSelectedImage") : UIImage(named: "nextButtonImage"), for: .normal)
        case 3:
            // 알약 개수가 선택되었는지 확인
            let pillCountSelected = selectedPillCountForQuestion3 != nil
            nextButton.isEnabled = pillCountSelected
            nextButton.setImage(pillCountSelected ? UIImage(named: "nextButtonSelectedImage") : UIImage(named: "nextButtonImage"), for: .normal)
        default:
            nextButton.isEnabled = false
        }
    }

    func setupPickerContainerView() {
        pickerContainerView = UIView()
        view.addSubview(pickerContainerView)
        pickerContainerView.layer.borderWidth = 1.0
        pickerContainerView.layer.borderColor = UIColor.tertiaryLabel.cgColor
        pickerContainerView.layer.cornerRadius = 20
        pickerContainerView.backgroundColor = .white
        pickerContainerView.isHidden = true // Initially hidden
        
        pickerContainerView.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.bottom).offset(200) // Initially off-screen
            make.left.right.equalTo(view).inset(20)
            make.height.equalTo(200)
        }
        
        setupTimePickerView()
    }
    
    func setupTimePickerView() {
        timePickerView = UIPickerView()
        pickerContainerView.addSubview(timePickerView)
        timePickerView.delegate = self
        timePickerView.dataSource = self
        
        timePickerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    func setupProgressView() {
        progressView = UIProgressView(progressViewStyle: .default)
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalTo(view).inset(20)
            make.height.equalTo(4)
        }
        progressView.progressTintColor = UIColor.pointThemeColor2
        progressView.trackTintColor = .lightGray
    }
    
    func setupLabels() {
        questionLabel = UILabel()
        questionLabel.numberOfLines = 0
        questionLabel.textAlignment = .center
        questionLabel.font = UIFont.preferredFont(forTextStyle: .title2).withTraits(.traitBold)
        view.addSubview(questionLabel)
        
        medicationReminderLabel = UILabel()
        medicationReminderLabel.numberOfLines = 0
        medicationReminderLabel.textAlignment = .center
        medicationReminderLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        view.addSubview(medicationReminderLabel)
        
        questionLabel.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(20)
            make.left.right.equalTo(view).inset(20)
        }
        
        medicationReminderLabel.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(20)
            make.left.right.equalTo(view).inset(20)
        }
    }
    
    
    func setupNavigationButtons() {
        nextButton = UIButton()
        previousButton = UIButton()
        
        nextButton.setImage(UIImage(named: "nextButtonImage"), for: .normal)
        previousButton.setImage(UIImage(named: "previousButtonImage"), for: .normal)
        
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        previousButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        
        view.addSubview(nextButton)
        view.addSubview(previousButton)
        
        nextButton.snp.makeConstraints { make in
            make.right.equalTo(view.snp.right).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.width.height.equalTo(65)
        }
        
        previousButton.snp.makeConstraints { make in
            make.left.equalTo(view.snp.left).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.width.height.equalTo(65)
        }
    }
    
    func setupMealTimeLabels() {
        // 아침, 점심, 저녁 식사 시간 라벨 생성 및 레이아웃 설정
        breakfastTimeLabel = createMealTimeLabel(text: "아침식사시간")
        lunchTimeLabel = createMealTimeLabel(text: "점심식사시간")
        dinnerTimeLabel = createMealTimeLabel(text: "저녁식사시간")
        
        // 선택한 시간을 표시하는 라벨 생성 및 레이아웃 설정
        selectedBreakfastTimeLabel = createSelectedTimeLabel()
        selectedLunchTimeLabel = createSelectedTimeLabel()
        selectedDinnerTimeLabel = createSelectedTimeLabel()
        
        // 라벨 위치 설정
        breakfastTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(questionLabel.snp.bottom).offset(80)
            make.centerX.equalToSuperview()
        }
        selectedBreakfastTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(breakfastTimeLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        lunchTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(selectedBreakfastTimeLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        selectedLunchTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(lunchTimeLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        dinnerTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(selectedLunchTimeLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        selectedDinnerTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(dinnerTimeLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
    }
    
    
    
    
    func setupSelectedCountLabel() {
        selectedCountLabel = UILabel()
        selectedCountLabel.textAlignment = .center
        selectedCountLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        selectedCountLabel.isHidden = true // Initially hidden
        view.addSubview(selectedCountLabel)
        
        selectedCountLabel.snp.makeConstraints { make in
            make.top.equalTo(pickerContainerView.snp.bottom).offset(20)
            make.centerX.equalTo(view)
            make.height.equalTo(50)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectedCountLabelTapped))
        selectedCountLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func nextButtonTapped() {
        if currentQuestion < 3 {
            currentQuestion += 1
            updateUI(for: currentQuestion)
        }
    }
    
    @objc func previousButtonTapped() {
        if currentQuestion > 1 {
            currentQuestion -= 1
            updateUI(for: currentQuestion)
        }
    }
    
    func updateUI(for questionNumber: Int) {
        intervalLabel.isHidden = true
        selectedCountLabel.isHidden = true
        breakfastTimeLabel.isHidden = true
        lunchTimeLabel.isHidden = true
        dinnerTimeLabel.isHidden = true
        selectedBreakfastTimeLabel.isHidden = true
        selectedLunchTimeLabel.isHidden = true
        selectedDinnerTimeLabel.isHidden = true
        pickerContainerView.isHidden = true
        selectedPillCountLabel.isHidden = true
        selectedIntervalLabel.isHidden = true
        
        timePickerView.reloadAllComponents()
        
        switch questionNumber {
        case 1:
            questionLabel.text = "Q. 000님이 주로 식사하는 시간대를 알려주세요!"
            medicationReminderLabel.text = "식전, 식후에 맞춰 약 섭취에 대한 알람을 보내드릴게요 :)"
            progressView.setProgress(0.25, animated: true)
            breakfastTimeLabel.isHidden = false
            lunchTimeLabel.isHidden = false
            dinnerTimeLabel.isHidden = false
            selectedBreakfastTimeLabel.isHidden = false
            selectedLunchTimeLabel.isHidden = false
            selectedDinnerTimeLabel.isHidden = false
            showPickerView()
        case 2:
            questionLabel.text = "Q. 식전, 식후 알람이 식사시간 몇 분의 간격을 두고 울리게 할까요?"
            medicationReminderLabel.text = "원하는 시간에 맞춰 약 섭취에 대한 알람을 보내드릴게요 :)"
            progressView.setProgress(0.5, animated: true)
            intervalLabel.isHidden = false
            selectedIntervalLabel.isHidden = false
            showPickerView()
        case 3:
            questionLabel.text = "Q. 등록하고 싶은 알약의 종류는 몇 가지인가요?"
            medicationReminderLabel.text = "알약 종류의 개수에 따라 캘린더 등록을 도와드릴게요 :)"
            progressView.setProgress(0.75, animated: true)
            selectedCountLabel.isHidden = false
            selectedPillCountLabel.isHidden = false
            showPickerView()
        default:
            hidePickerView()
        }
        //        timePickerView.reloadAllComponents()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch currentQuestion {
        case 1:
            return 3
        case 2, 3:
            return 1
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch currentQuestion {
        case 1:
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
        case 2:
            return intervalMinutes.count
        case 3:
            return pillCounts.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch currentQuestion {
        case 1:
            switch component {
            case 0:
                return row < meridiem.count ? meridiem[row] : nil
            case 1:
                return row < hours.count ? "\(hours[row])시" : nil
            case 2:
                return row < minutes.count ? "\(minutes[row])분" : nil
            default:
                return nil
            }
        case 2:
            return row < intervalMinutes.count ? "\(intervalMinutes[row])분" : nil
        case 3:
            return row < pillCounts.count ? "\(pillCounts[row])개" : nil
        default:
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch currentQuestion {
        case 1:
            let selectedHour = hours[pickerView.selectedRow(inComponent: 1)]
            let selectedMinute = pickerView.selectedRow(inComponent: 2)
            let selectedMeridiem = meridiem[pickerView.selectedRow(inComponent: 0)]
            tempSelectedTime = (hour: selectedHour, minute: selectedMinute, meridiem: selectedMeridiem)
        case 2:
            let selectedInterval = intervalMinutes[row]
            tempSelectedInterval = selectedInterval
        case 3:
            let selectedCount = pillCounts[row]
            tempSelectedPillCount = selectedCount
        default:
            break
        }
    }

    
    func showPickerView() {
        pickerContainerView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.pickerContainerView.snp.remakeConstraints { make in
                make.bottom.equalTo(self.view.snp.bottom).offset(-200)
                make.left.right.equalTo(self.view).inset(20)
                make.height.equalTo(200)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func hidePickerView() {
        UIView.animate(withDuration: 0.3) {
            self.pickerContainerView.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.snp.bottom).offset(200)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func createMealTimeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        label.font = FontLiteral.title3(style: .bold)
        label.textColor = UIColor.pointThemeColor
        
        view.addSubview(label)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mealTimeLabelTapped(_:)))
        label.addGestureRecognizer(tapGesture)
        
        return label
    }
    
    func createSelectedTimeLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        view.addSubview(label)
        return label
    }
    
    @objc func mealTimeLabelTapped(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else { return }
        
        switch label {
        case breakfastTimeLabel:
            currentSelectedMealType = .breakfast
        case lunchTimeLabel:
            currentSelectedMealType = .lunch
        case dinnerTimeLabel:
            currentSelectedMealType = .dinner
        default:
            return
        }
        showPickerView()
    }
    
    @objc func selectedCountLabelTapped() {
        showPickerView()
    }
}
