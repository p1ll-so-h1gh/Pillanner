//
//  UserMainViewController.swift
//  Pillanner
//
//  Created by 영현 on 2/22/24.
//

// 약 지우거나, 업데이트 하거나 했을 때, 바로바로 업데이트 안되는 문제 해결해야 함

import UIKit
import SnapKit

final class UserMainCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let height = self.contentSize.height + self.contentInset.top + self.contentInset.bottom
        return CGSize(width: self.contentSize.width, height: height)
    }
}

final class UserMainViewController: UIViewController {
    //배경 깔아주기
    private lazy var gradientLayer = CAGradientLayer.dayBackgroundLayer(view: view)
    private let sidePaddingSizeValue = 20
    
    // MARK: - TO DO
    // CollectionView에 뿌려줄 데이터 타입 정의 필요
    private var pillsList = [Pill]()
    
    private let attainment: Attainment
    private var attainmentRate: Int = 0
    
    init(attainment: Attainment) {
        self.attainment = attainment
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI Properties
    private let topView: UIView = {
        var view = UIView()
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        //        label.text = "\("")님"
        label.font = FontLiteral.title2(style: .bold).withSize(24)
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = FontLiteral.body(style: .regular).withSize(14)
        label.alpha = 0.5
        return label
    }()
    
    private lazy var settingButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        button.tintColor = UIColor.black
        button.addTarget(self, action: #selector(goSettingVC), for: .touchUpInside)
        return button
    }()
    
    @objc func goSettingVC() {
        let settingVC = UserSettingViewController()
        let nav = UINavigationController(rootViewController: settingVC)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    private let scrollView: UIScrollView = {
        var view = UIScrollView()
        return view
    }()
    
    private let attainmentRateLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘의 달성률"
        label.font = FontLiteral.title2(style: .bold).withSize(20)
        return label
    }()
    
    private let circleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private let sectionSeparatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.3
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 1)
        return view
    }()
    
    private let intakePillLabel: UILabel = {
        let label = UILabel()
        label.text = "복용중인 약"
        label.font = FontLiteral.title2(style: .bold).withSize(20)
        return label
    }()
    
    private let intakeDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = FontLiteral.body(style: .regular).withSize(14)
        label.alpha = 0.5
        return label
    }()
    
    private let intakePillListCollectionView: UserMainCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 70), height: 70)
        
        let collectionView = UserMainCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.addSublayer(gradientLayer)
        addSubView()
        setUpLayout()
        intakePillListCollectionView.delegate = self
        intakePillListCollectionView.dataSource = self
        intakePillListCollectionView.register(PillListCollectionViewCell.self, forCellWithReuseIdentifier: PillListCollectionViewCell.id)
    }
    
    //이후에 타이머 초기화 해주는 것 호출 추가 필요
    override func viewWillAppear(_ animated: Bool) {
        //뷰가 나타날때마다 애니메이션 효과 주기 위해
        attainment.attainmentDidChange = { calculatedData in
            self.attainmentRate = calculatedData
        }
        createCircle()
        
        if self.pillsList.isEmpty {
            setUpLabelsTextWithUserInformation()
        }
        self.readPillDataFromFirestore()
    }
    
    
    //MARK: - Add SubView
    private func addSubView() {
        [topView, scrollView].forEach {
            self.view.addSubview($0)
        }
        [nameLabel, infoLabel, settingButton].forEach {
            topView.addSubview($0)
        }
        [attainmentRateLabel, circleContainerView, sectionSeparatorLine, intakePillLabel, intakeDescriptionLabel, intakePillListCollectionView].forEach {
            scrollView.addSubview($0)
        }
    }
    
    //MARK: - View Contraints
    private func setUpLayout() {
        topView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(90)
        }
        nameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(sidePaddingSizeValue)
        }
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).inset(-5)
            $0.leading.bottom.equalToSuperview().inset(sidePaddingSizeValue)
        }
        settingButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(sidePaddingSizeValue)
        }
        scrollView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.width.equalToSuperview()
        }
        attainmentRateLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(sidePaddingSizeValue)
        }
        circleContainerView.snp.makeConstraints {
            $0.size.equalTo(220)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(attainmentRateLabel.snp.bottom).inset(-30)
        }
        sectionSeparatorLine.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(sidePaddingSizeValue)
            $0.width.equalTo(353)
            $0.height.equalTo(1)
            $0.top.equalTo(circleContainerView.snp.bottom).inset(-sidePaddingSizeValue)
        }
        intakePillLabel.snp.makeConstraints {
            $0.top.equalTo(sectionSeparatorLine.snp.bottom).inset(-sidePaddingSizeValue)
            $0.leading.equalToSuperview().inset(sidePaddingSizeValue)
        }
        intakeDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(intakePillLabel.snp.bottom).inset(-5)
            $0.leading.equalToSuperview().inset(sidePaddingSizeValue)
        }
        intakePillListCollectionView.snp.makeConstraints {
            $0.top.equalTo(intakeDescriptionLabel.snp.bottom).inset(-10)
            $0.leading.trailing.bottom.equalToSuperview().inset(sidePaddingSizeValue)
            $0.height.greaterThanOrEqualTo(1)
        }
    }
    
    // MARK: - Set Up Data
    private func readPillDataFromFirestore() {
        guard let UID = UserDefaults.standard.string(forKey: "UID") else { return }
        DataManager.shared.readPillListData(UID: UID) { list in
            var tempList = [Pill]()
            guard let list = list else {
                if list == nil {
                    self.pillsList = []
                    self.setUpLabelsTextWithUserInformation()
                    self.intakePillListCollectionView.reloadData()
                    return
                }
                return
            }
            for pill in list {
                let receiver = Pill(title: pill["Title"] as? String ?? "ftitle",
                                    type: pill["Type"] as? String ?? "ftype",
                                    day: pill["Day"] as? [String] ?? ["fday"],
                                    dueDate: pill["DueDate"] as? String ?? "fduedate",
                                    intake: pill["Intake"] as? [String] ?? ["fintake"],
                                    dosage: pill["Dosage"] as? String ?? "fdosage",
                                    alarmStatus: pill["AlarmStatus"] as? Bool ?? true)
                tempList.append(receiver)
                self.pillsList = tempList
                self.intakePillListCollectionView.reloadData()
                self.setUpLabelsTextWithUserInformation()
            }
        }
    }
    
    
    private func setUpLabelsTextWithUserInformation() {
        
        guard let nickname = UserDefaults.standard.string(forKey: "Nickname") else { return }
        nameLabel.text = "\(nickname)님"
        infoLabel.text = "\(nickname)님! 오늘도 잊지않고 약 챙겨드세요! :)" // 다 먹기 전/ 후 분기처리 필요
        // 혹은 그냥 응원의 문구를 적어 넣는 것도 나쁘지 않을지도?
        // 해당 문구 아래에 달성률이 이 역할을 할 것이기 때문에...
        if pillsList.isEmpty {
            intakeDescriptionLabel.text = "\(nickname)님, 아직 등록하신 약이 없으시네요!"
        } else {
            intakeDescriptionLabel.text = "\(nickname)님이 복용중인 약은 \(pillsList.count) 개 입니다"
        }
    }
    
    //MARK: - Attainment Circle
    // 하루, 일주일, 월별 -> 하루 달성률만 표시되도록 축소
    private func createCircle() {
        let dayCircleRadius: CGFloat = 100
        let circleLineWidth: CGFloat = 30.0
        let attainmentGoal = CGFloat(self.attainmentRate) / 100.0
        
        //원경로
        let dayCircularPath = UIBezierPath(arcCenter: CGPoint(x: 110, y: 110), 
                                           radius: dayCircleRadius,
                                           startAngle: -CGFloat.pi / 2,
                                           endAngle: 2 * CGFloat.pi * attainmentGoal - CGFloat.pi / 2,
                                           clockwise: true)
        let dayBackgroundCircularPath = UIBezierPath(arcCenter: CGPoint(x: 110, y: 110), 
                                                     radius: dayCircleRadius, 
                                                     startAngle: -CGFloat.pi / 2,
                                                     endAngle: 2 * CGFloat.pi,
                                                     clockwise: true)
        
        //정답률 테두리
        let dayBorderLine = CAShapeLayer()
        dayBorderLine.path = dayCircularPath.cgPath
        dayBorderLine.strokeColor = UIColor(hexCode: "FF9898").cgColor
        dayBorderLine.lineWidth = circleLineWidth
        dayBorderLine.fillColor = UIColor.clear.cgColor
        dayBorderLine.lineCap = CAShapeLayerLineCap.round
        
        let dayBackgroundCircularLine = CAShapeLayer()
        dayBackgroundCircularLine.path = dayBackgroundCircularPath.cgPath
        dayBackgroundCircularLine.strokeColor = UIColor(hexCode: "FFE5E5").cgColor
        dayBackgroundCircularLine.lineWidth = circleLineWidth
        dayBackgroundCircularLine.fillColor = UIColor.clear.cgColor
        
        circleContainerView.layer.addSublayer(dayBackgroundCircularLine)
        circleContainerView.layer.addSublayer(dayBorderLine)
        
        if  let newAttainmentLabel = circleContainerView.viewWithTag(20240320426) as? UILabel {
            newAttainmentLabel.text = "\(self.attainmentRate) %"
        } else {
            // 정답률 label
            let attainmentLabel = UILabel()
            attainmentLabel.text = "\(self.attainmentRate) %"
            attainmentLabel.tag = 20240320426
            attainmentLabel.textColor = UIColor(hexCode: "F97474")
            attainmentLabel.font = FontLiteral.title2(style: .bold).withSize(30)
            
            
            circleContainerView.addSubview(attainmentLabel)
            attainmentLabel.snp.makeConstraints {
                $0.centerX.centerY.equalToSuperview()
            }
        }
        
        //테두리 애니메이션
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1.5
        dayBorderLine.add(animation,forKey: "progressAnimation")
    }
}


//MARK: - Pill CollectionView

extension UserMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pillsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PillListCollectionViewCell", for: indexPath) as! PillListCollectionViewCell
        let pill = pillsList[indexPath.row]
        
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.pillListViewDelegate = self
        
        cell.configureCell(with: pill)
        
        return cell
    }
    
    // 위 아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionView.invalidateIntrinsicContentSize()
        collectionView.layoutIfNeeded()
    }
}

//MARK: - UIStackView Extension
extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
}

//MARK: - PillListViewDelegate
extension UserMainViewController: PillListViewDelegate {
    func deletePill(pillData: String) {
        let title = "\(pillData)을 정말 삭제하시겠습니까?"
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "아니요", style: .default)
        let delete = UIAlertAction(title: "네", style: .default) { _ in
            DataManager.shared.deletePillData(title: pillData)
            self.readPillDataFromFirestore()
            self.intakePillListCollectionView.reloadData()
        }
        alert.addAction(delete)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func editPill(pillData: Pill) {
        let VC = PillEditViewController(pill: pillData)
        VC.modalPresentationStyle = .fullScreen
        present(VC, animated: true, completion: nil)
    }
}

