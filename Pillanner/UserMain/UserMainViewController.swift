//
//  UserMainViewController.swift
//  Pillanner
//
//  Created by 영현 on 2/22/24.
//

import UIKit
import SnapKit
import SwiftUI

//struct PreView: PreviewProvider {
//    static var previews: some View {
//        UserMainViewController().toPreview()
//    }
//}
//
//#if DEBUG
//extension UIViewController {
//    private struct Preview: UIViewControllerRepresentable {
//        let viewController: UIViewController
//
//        func makeUIViewController(context: Context) -> UIViewController {
//            return viewController
//        }
//
//        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        }
//    }
//
//    func toPreview() -> some View {
//        Preview(viewController: self)
//    }
//}
//#endif

final class UserMainViewController: UIViewController {
    
    //배경 깔아주기
    private lazy var gradientLayer = CAGradientLayer.dayBackgroundLayer(view: view)
    
    //MARK: - UI Properties
    private let scrollView: UIScrollView = {
        var view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        return view
    }()
    private let contentView: UIView = {
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
    private let settingBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        button.tintColor = UIColor.black
        return button
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
    private let daytextLabel: UILabel = {
        let label = UILabel()
        label.text = "하루"
        label.font = FontLiteral.body(style: .regular).withSize(14)
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
    private let weektextLabel: UILabel = {
        let label = UILabel()
        label.text = "일주일"
        label.font = FontLiteral.body(style: .regular).withSize(14)
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
    private let monthtextLabel: UILabel = {
        let label = UILabel()
        label.text = "월별"
        label.font = FontLiteral.body(style: .regular).withSize(14)
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
    private let intakedescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "영현님이 복용중인 약은 00 개 입니다"
        label.font = FontLiteral.body(style: .regular).withSize(14)
        label.alpha = 0.5
        return label
    }()
    private let intakePillListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 70), height: 70)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        intakePillListCollectionView.delegate = self
        intakePillListCollectionView.dataSource = self
        
        let pillListnib = UINib(nibName: "PillListCollectionViewCell", bundle: nil)
        intakePillListCollectionView.register(pillListnib, forCellWithReuseIdentifier: "PillListCollectionViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.layer.addSublayer(gradientLayer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addSubView()
        setUpLayout()
        createCircle()
        
    }
    
    //MARK: - AddSubView
    private func addSubView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        //전체적인 뷰 세팅
        [nameLabel, infoLabel, settingBtn, attainmentRateLabel, circleContainerView, labelVStackView, sectionSeparatorLine, intakePillLabel, intakedescriptionLabel, intakePillListCollectionView].forEach {
            contentView.addSubview($0)
        }
        
        dayView.addSubview(dayLabel)
        dayView.addSubview(daytextLabel)
        weekView.addSubview(weekLabel)
        weekView.addSubview(weektextLabel)
        monthView.addSubview(monthLabel)
        monthView.addSubview(monthtextLabel)
        labelVStackView.addArrangedSubviews(dayView, weekView, monthView)
    }
    
    //MARK: - View Contraints
    private func setUpLayout() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(self.view.safeAreaLayoutGuide.snp.height)
        }
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).inset(27)
            $0.top.equalTo(contentView).inset(50)
        }
        infoLabel.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).inset(30)
            $0.top.equalTo(nameLabel.snp.bottom).inset(-5)
        }
        settingBtn.snp.makeConstraints {
            $0.trailing.equalTo(contentView.snp.trailing).inset(20)
            $0.top.equalTo(contentView.snp.top).inset(50)
        }
        attainmentRateLabel.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).inset(37)
            $0.top.equalTo(infoLabel.snp.bottom).inset(-25)
        }
        circleContainerView.snp.makeConstraints {
            $0.size.equalTo(220)
            $0.leading.equalTo(contentView).inset(30)
            $0.top.equalTo(attainmentRateLabel.snp.bottom).inset(-30)
            $0.bottom.equalTo(sectionSeparatorLine.snp.top).inset(-20)
        }
        labelVStackView.snp.makeConstraints {
            $0.leading.equalTo(circleContainerView.snp.trailing).inset(-30)
            $0.trailing.equalTo(contentView.snp.trailing).inset(10)
            $0.top.equalTo(contentView.snp.top).offset(200)
        }
        dayLabel.snp.makeConstraints {
            $0.size.equalTo(12)
            $0.leading.equalTo(dayView.snp.leading)
        }
        daytextLabel.snp.makeConstraints {
            $0.leading.equalTo(dayLabel.snp.trailing).inset(5)
        }
        weekLabel.snp.makeConstraints {
            $0.size.equalTo(12)
            $0.leading.equalTo(weekView.snp.leading)
        }
        weektextLabel.snp.makeConstraints {
            $0.leading.equalTo(weekLabel.snp.trailing).inset(5)
        }
        monthLabel.snp.makeConstraints {
            $0.size.equalTo(12)
            $0.leading.equalTo(monthView.snp.leading)
        }
        monthtextLabel.snp.makeConstraints {
            $0.leading.equalTo(monthLabel.snp.trailing).inset(5)
        }
        sectionSeparatorLine.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(circleContainerView.snp.bottom).inset(-5)
            $0.leadingMargin.trailingMargin.equalTo(contentView).inset(20)
        }
        intakePillLabel.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).inset(37)
            $0.top.equalTo(sectionSeparatorLine.snp.bottom).inset(-15)
        }
        intakedescriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).inset(40)
            $0.top.equalTo(intakePillLabel.snp.bottom).inset(-5)
        }
        intakePillListCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalTo(contentView).inset(37)
            $0.top.equalTo(intakedescriptionLabel.snp.bottom).inset(-10)
            $0.bottom.equalTo(contentView.snp.bottom).inset(30)
        }
    }
    
    //MARK: - Attainmet Circle
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
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PillListCollectionViewCell", for: indexPath) as! PillListCollectionViewCell
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true

        cell.typeLabel.text = "일반"
        cell.nameLabel.text = "유산균"
        cell.alarmLabel.text = "off"
        cell.pillnumLabel.text = "하루 1정"
        
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

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
}
