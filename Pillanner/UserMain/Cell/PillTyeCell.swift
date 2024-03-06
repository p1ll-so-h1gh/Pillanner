//
//  PillTyeCell.swift
//  Pillanner
//
//  Created by 박민정 on 2/29/24.
//

import UIKit
import SnapKit

final class PillTyeCell: UITableViewCell {
    static let id = "PillTyeCell"
    private let sidePaddingSizeValue = 20
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "일반 / 처방"
        label.font = FontLiteral.subheadline(style: .bold).withSize(18)
        label.alpha = 0.6
        return label
    }()
    private let generalPillView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor(hexCode: "E6E6E6")
        return view
    }()
    private let generalPillBtn: UIButton = {
        let button = UIButton()
        button.setTitle("일반", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    private let prescriptionPillView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor(hexCode: "E6E6E6")
        return view
    }()
    private let prescriptionPillBtn: UIButton = {
        let button = UIButton()
        button.setTitle("처방", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    private let HStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.spacing = 10
        return stackview
    }()
//    lazy private var typesegCon: UISegmentedControl = {
//        let control = UISegmentedControl(items: array)
//        control.backgroundColor = UIColor(hexCode: "E6E6E6")
//        control.selectedSegmentTintColor = UIColor.mainThemeColor
//        control.addTarget(self, action: #selector(segconChanged(segcon:)), for: UIControl.Event.valueChanged)
//        control.setWidth(150, forSegmentAt: 0)
//        control.setWidth(150, forSegmentAt: 1)
//        return control
//    }()
//    @objc func segconChanged(segcon: UISegmentedControl) {
//        //이후 저장 작업
//    }
//    private let array: [String] = ["일반", "처방"]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.setupLayout()
        generalPillBtn.addTarget(self, action: #selector(tappedgeneralPillBtn), for: .touchUpInside)
        prescriptionPillBtn.addTarget(self, action: #selector(tappedprescriptionPillBtn), for: .touchUpInside)
    }
    @objc func tappedgeneralPillBtn() {
        generalPillView.backgroundColor = UIColor.mainThemeColor
        prescriptionPillView.backgroundColor = UIColor(hexCode: "E6E6E6")
    }
    @objc func tappedprescriptionPillBtn() {
        prescriptionPillView.backgroundColor = UIColor.mainThemeColor
        generalPillView.backgroundColor = UIColor(hexCode: "E6E6E6")
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupLayout() {
        generalPillView.addSubview(generalPillBtn)
        generalPillBtn.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        prescriptionPillView.addSubview(prescriptionPillBtn)
        prescriptionPillBtn.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        HStackView.addArrangedSubview(generalPillView)
        HStackView.addArrangedSubview(prescriptionPillView)
        [titleLabel, HStackView].forEach {
            contentView.addSubview($0)
        }
//        self.contentView.addSubview(self.typesegCon)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(sidePaddingSizeValue)
            $0.left.equalToSuperview().inset(sidePaddingSizeValue)
        }
        generalPillView.snp.makeConstraints {
            $0.width.equalTo(157)
            $0.height.equalTo(47)
        }
        prescriptionPillView.snp.makeConstraints {
            $0.width.equalTo(157)
            $0.height.equalTo(47)
        }
        HStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).inset(-sidePaddingSizeValue)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(sidePaddingSizeValue)
        }
//        self.typesegCon.snp.makeConstraints {
//            $0.top.equalTo(self.titleLabel.snp.bottom).inset(-sidePaddingSizeValue)
//            $0.centerX.equalToSuperview()
//            $0.height.equalTo(40)
//            $0.bottom.equalToSuperview().inset(sidePaddingSizeValue)
//        }
    }
    
}
