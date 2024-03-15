//
//  UserMainViewController.swift
//  Pillanner
//
//  Created by 영현 on 2/22/24.
//

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
    
    //MARK: - UI Properties
    
    private let topView: UIView = {
        var view = UIView()
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "김영현님"
        label.font = FontLiteral.title2(style: .bold).withSize(24)
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "영현님! 오늘 알약 섭취를 70% 완료 하셨어요 :)"
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
        label.text = "달성률"
        label.font = FontLiteral.title2(style: .bold).withSize(20)
        return label
    }()
    
    private let circleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let labelVStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 50
        return stackView
    }()
    
    private let dayLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 12, height: 12)
        label.layer.cornerRadius = label.frame.size.width/2
        label.clipsToBounds = true
        label.backgroundColor = UIColor(hexCode: "9BDCFD")
        return label
    }()
    
    private let dayTextLabel: UILabel = {
        let label = UILabel()
        label.text = "하루"
        label.font = FontLiteral.body(style: .regular).withSize(18)
        return label
    }()
    
    private let dayView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let weekLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 12, height: 12)
        label.layer.cornerRadius = label.frame.size.width/2
        label.clipsToBounds = true
        label.backgroundColor = UIColor(hexCode: "FF9898")
        return label
    }()
    
    private let weekTextLabel: UILabel = {
        let label = UILabel()
        label.text = "일주일"
        label.font = FontLiteral.body(style: .regular).withSize(18)
        return label
    }()
    
    private let weekView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let monthLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 12, height: 12)
        label.layer.cornerRadius = label.frame.size.width/2
        label.clipsToBounds = true
        label.backgroundColor = UIColor(hexCode: "FFD188")
        return label
    }()
    
    private let monthTextLabel: UILabel = {
        let label = UILabel()
        label.text = "월별"
        label.font = FontLiteral.body(style: .regular).withSize(18)
        return label
    }()
    
    private let monthView: UIView = {
        let view = UIView()
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
        label.text = "영현님이 복용중인 약은 00 개 입니다"
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
        readPillDataFromFirestore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //뷰가 나타날때마다 애니메이션 효과 주기 위해
        createCircle()
        setUpLabelsTextWithUserInformation()
    }
    
    //MARK: - AddSubView
    private func addSubView() {
        [topView, scrollView].forEach {
            self.view.addSubview($0)
        }
        [nameLabel, infoLabel, settingButton].forEach {
            topView.addSubview($0)
        }
        [attainmentRateLabel, circleContainerView, labelVStackView, sectionSeparatorLine, intakePillLabel, intakeDescriptionLabel, intakePillListCollectionView].forEach {
            scrollView.addSubview($0)
        }      
        dayView.addSubview(dayLabel)
        dayView.addSubview(dayTextLabel)
        weekView.addSubview(weekLabel)
        weekView.addSubview(weekTextLabel)
        monthView.addSubview(monthLabel)
        monthView.addSubview(monthTextLabel)
        labelVStackView.addArrangedSubviews(dayView, weekView, monthView)
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
            $0.leading.equalToSuperview().inset(sidePaddingSizeValue*2)
            $0.top.equalTo(attainmentRateLabel.snp.bottom).inset(-30)
        }
        labelVStackView.snp.makeConstraints {
            $0.leading.equalTo(circleContainerView.snp.trailing).inset(-30)
            $0.trailing.equalToSuperview().inset(sidePaddingSizeValue)
            $0.top.equalToSuperview().inset(100)
        }
        dayLabel.snp.makeConstraints {
            $0.size.equalTo(12)
            $0.leading.equalTo(dayView.snp.leading)
        }
        dayTextLabel.snp.makeConstraints {
            $0.leading.equalTo(dayLabel.snp.trailing).inset(-10)
            $0.centerY.equalTo(dayLabel.snp.centerY)
        }
        weekLabel.snp.makeConstraints {
            $0.size.equalTo(12)
            $0.leading.equalTo(weekView.snp.leading)
        }
        weekTextLabel.snp.makeConstraints {
            $0.leading.equalTo(weekLabel.snp.trailing).inset(-10)
            $0.centerY.equalTo(weekLabel.snp.centerY)
        }
        monthLabel.snp.makeConstraints {
            $0.size.equalTo(12)
            $0.leading.equalTo(monthView.snp.leading)
        }
        monthTextLabel.snp.makeConstraints {
            $0.leading.equalTo(monthLabel.snp.trailing).inset(-10)
            $0.centerY.equalTo(monthLabel.snp.centerY)
        }
        sectionSeparatorLine.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(sidePaddingSizeValue)
            $0.width.equalTo(353)
            $0.height.equalTo(1)
            $0.top.equalTo(circleContainerView.snp.bottom).inset(-10)
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
                if let list = list {
                    for pill in list {
                        let receiver = Pill(title: pill["Title"] as! String,
                                            type: pill["Type"] as! String,
                                            day: pill["Day"] as! [String],
                                            dueDate: pill["DueDate"] as! String,
                                            intake: pill["Intake"] as! [String],
                                            dosage: pill["Dosage"] as! Double)
                        self.pillsList.append(receiver)
                    }
                }
            }
        }
        
        
        private func setUpLabelsTextWithUserInformation() {
            guard let nickname = UserDefaults.standard.string(forKey: "Nickname") else { return }
            nameLabel.text = "\(nickname)님"
            infoLabel.text = "\(nickname)님! 오늘 알약 섭취를 \(pillsList.count) 완료 하셨어요 :)" // 몇개 먹은지 수정 필요
            intakeDescriptionLabel.text = "\(nickname)님이 복용중인 약은 \(pillsList.count) 개 입니다"
        }
    

    //MARK: - Attainment Circle
    private func createCircle() {
        let daycircleRadius: CGFloat = 100
        let weekcircleRadius: CGFloat = 67
        let monthcircleRadius: CGFloat = 40
        let circleLineWidth: CGFloat = 15.0
        
        //원경로
        let daycircularPath = UIBezierPath(arcCenter: CGPoint(x: 100, y: 100), radius: daycircleRadius, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi , clockwise: true)
        let weekcircularPath = UIBezierPath(arcCenter: CGPoint(x: 100, y: 100), radius: weekcircleRadius, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi / 2 , clockwise: true)
        let monthcircularPath = UIBezierPath(arcCenter: CGPoint(x: 100, y: 100), radius: monthcircleRadius, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi / 3, clockwise: true)
        //정답률 테두리
        let dayborderLine = CAShapeLayer()
        dayborderLine.path = daycircularPath.cgPath
        dayborderLine.strokeColor = UIColor(hexCode: "9BDCFD").cgColor
        dayborderLine.lineWidth = circleLineWidth
        dayborderLine.fillColor = UIColor.clear.cgColor
        dayborderLine.lineCap = CAShapeLayerLineCap.round
        
        circleContainerView.layer.addSublayer(dayborderLine)
        
        let weekborderLine = CAShapeLayer()
        weekborderLine.path = weekcircularPath.cgPath
        weekborderLine.strokeColor = UIColor(hexCode: "FF9898").cgColor
        weekborderLine.lineWidth = circleLineWidth
        weekborderLine.fillColor = UIColor.clear.cgColor
        weekborderLine.lineCap = CAShapeLayerLineCap.round
        
        circleContainerView.layer.addSublayer(weekborderLine)
        
        let monthborderLine = CAShapeLayer()
        monthborderLine.path = monthcircularPath.cgPath
        monthborderLine.strokeColor = UIColor(hexCode: "FFD188").cgColor
        monthborderLine.lineWidth = circleLineWidth
        monthborderLine.fillColor = UIColor.clear.cgColor
        monthborderLine.lineCap = CAShapeLayerLineCap.round
        
        circleContainerView.layer.addSublayer(monthborderLine)
        
        //테두리 애니메이션
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 1.5
        dayborderLine.add(animation,forKey: "progressAnimation")
        weekborderLine.add(animation,forKey: "progressAnimation")
        monthborderLine.add(animation,forKey: "progressAnimation")
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

//        cell.typeLabel.text = "일반"
//        cell.nameLabel.text = "유산균"
//        cell.alarmLabel.text = "off"
//        cell.pillnumLabel.text = "하루 1정"
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
        }
        alert.addAction(delete)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    func editPill(pillData: Pill) {
        let VC = PillEditViewController()
        VC.modalPresentationStyle = .fullScreen
        present(VC, animated: true, completion: nil)
    }
}


