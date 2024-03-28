//
//  PillTyeCell.swift
//  Pillanner
//
//  Created by 박민정 on 2/29/24.
//

import UIKit
import SnapKit

// 버튼 눌렀을 떄 반환값 필요

protocol PillTypeCellDelegate: AnyObject {
    func updatePillType(_ type: String)
}

final class PillTypeCell: UITableViewCell {
    
    weak var delegate: PillTypeCellDelegate?
    
    static let identifier = "PillTypeCell"
    private let sidePaddingSizeValue = 20
    private let cornerRadiusValue: CGFloat = 13
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "일반 / 처방"
        label.font = FontLiteral.subheadline(style: .bold).withSize(18)
        label.alpha = 0.6
        return label
    }()
    
    private lazy var generalPillView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = cornerRadiusValue
        view.backgroundColor = UIColor(hexCode: "E6E6E6")
        return view
    }()
    
    private let generalPillButton: UIButton = {
        let button = UIButton()
        button.setTitle("일반약", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    private lazy var prescriptionPillView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = cornerRadiusValue
        view.backgroundColor = UIColor(hexCode: "E6E6E6")
        return view
    }()
    
    private let prescriptionPillButton: UIButton = {
        let button = UIButton()
        button.setTitle("처방약", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    private let horizontalStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.spacing = 15
        return stackview
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        generalPillButton.addTarget(self, action: #selector(tappedgeneralPillButton), for: .touchUpInside)
        prescriptionPillButton.addTarget(self, action: #selector(tappedprescriptionPillButton), for: .touchUpInside)
    }
    
    @objc func tappedgeneralPillButton() {
        generalPillView.layer.borderWidth = 2
        generalPillView.backgroundColor = .white
        generalPillView.layer.borderColor = UIColor.pointThemeColor2.cgColor
        prescriptionPillView.layer.borderColor = UIColor(hexCode: "E6E6E6").cgColor
        prescriptionPillView.backgroundColor = UIColor(hexCode: "E6E6E6")
        delegate?.updatePillType("일반")
    }
    
    @objc func tappedprescriptionPillButton() {
        prescriptionPillView.layer.borderWidth = 2
        prescriptionPillView.backgroundColor = .white
        prescriptionPillView.layer.borderColor = UIColor.pointThemeColor2.cgColor
        generalPillView.layer.borderColor = UIColor(hexCode: "E6E6E6").cgColor
        generalPillView.backgroundColor = UIColor(hexCode: "E6E6E6")
        delegate?.updatePillType("처방")
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func changeButtonStateWithPresetData(type: String) {
        if type == "일반" {
            generalPillView.layer.borderWidth = 2
            generalPillView.backgroundColor = .white
            generalPillView.layer.borderColor = UIColor.pointThemeColor2.cgColor
            prescriptionPillView.layer.borderColor = UIColor(hexCode: "E6E6E6").cgColor
            prescriptionPillView.backgroundColor = UIColor(hexCode: "E6E6E6")
        } else if type == "처방" {
            prescriptionPillView.layer.borderWidth = 2
            prescriptionPillView.backgroundColor = .white
            prescriptionPillView.layer.borderColor = UIColor.pointThemeColor2.cgColor
            generalPillView.layer.borderColor = UIColor(hexCode: "E6E6E6").cgColor
            generalPillView.backgroundColor = UIColor(hexCode: "E6E6E6")
        }
    }
    
    func setupLayoutOnEditingProcess(type: String) {
        
        changeButtonStateWithPresetData(type: type)
        
        generalPillView.addSubview(generalPillButton)
        generalPillButton.snp.makeConstraints {
            $0.top.bottom.leading.trailing.centerX.centerY.equalToSuperview()
        }
        prescriptionPillView.addSubview(prescriptionPillButton)
        prescriptionPillButton.snp.makeConstraints {
            $0.top.bottom.leading.trailing.centerX.centerY.equalToSuperview()
        }
        horizontalStackView.addArrangedSubview(generalPillView)
        horizontalStackView.addArrangedSubview(prescriptionPillView)
        [titleLabel, horizontalStackView].forEach {
            contentView.addSubview($0)
        }
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
        horizontalStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).inset(-sidePaddingSizeValue)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(sidePaddingSizeValue)
        }
    }
    
    //cell 초기화 함수 - 선택된 버튼 없도록
    internal func reset() {
    }
}
