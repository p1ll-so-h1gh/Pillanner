//
//  IntakeNumberCell.swift
//  Pillanner
//
//  Created by 박민정 on 3/25/24.
//

import UIKit
import SnapKit

protocol intakeNumberCellDelegate: AnyObject {
    func updateDosage(dosage: String)
    func updateUnit(unit: String)
}

final class IntakeNumberCell: UITableViewCell {
    
    static let identifier = "IntakeNumberCell"
    private let sidePaddingSizeValue = 20
    private let dosageUnits = ["캡슐", "정", "개", "포", "병", "g", "ml"]
    private var isDropdownVisible = false
    
    weak var delegate: intakeNumberCellDelegate?
    
    private let dosageCountLabel: UILabel = {
        let label = UILabel()
        label.text = "1회 섭취 개수"
        label.font = FontLiteral.subheadline(style: .bold).withSize(18)
        label.frame = CGRect(x: 0, y: 0, width: 50, height: 24)
        label.alpha = 0.6
        return label
    }()
    
    private let dosageInputContainer: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.tertiaryLabel.cgColor
        view.layer.cornerRadius = 10
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var dosageNumberInputTextField: UITextField = {
        let textfield = UITextField()
        textfield.keyboardType = .numberPad
        textfield.placeholder = "복용량 개수 입력"
        textfield.textAlignment = .center
        textfield.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        return textfield
    }()
    
    @objc private func textFieldDidChanged(_ sender: Any) {
        self.delegate?.updateDosage(dosage: self.dosageNumberInputTextField.text ?? "")
    }
    
    private let dosageUnitButtonView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 13
        view.backgroundColor = UIColor(hexCode: "E6E6E6")
        return view
    }()
    
    private lazy var dosageUnitButton: UIButton = {
        let button = UIButton()
        button.setTitle("단위 선택", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = FontLiteral.body(style: .regular)
        button.layer.borderWidth = 0
        button.layer.cornerRadius = 10
        button.backgroundColor = UIColor.pointThemeColor2
        
        button.addTarget(self, action: #selector(toggleDropdown), for: .touchUpInside)
        return button
    }()
    
    @objc private func toggleDropdown() {
        isDropdownVisible.toggle()
        dosageUnitTableView.isHidden = !isDropdownVisible
    }
    
    private let dosageUnitTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        return tableView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.dosageUnitTableView.delegate = self
        self.dosageUnitTableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupLayoutOnEditingProcess(dosage: String, unit: String) {
        self.dosageNumberInputTextField.text = dosage
        self.dosageUnitButton.setTitle(unit, for: .normal)
        
        self.contentView.addSubview(dosageCountLabel)
        self.contentView.addSubview(dosageInputContainer)
        dosageInputContainer.addSubview(dosageNumberInputTextField)
        self.contentView.addSubview(dosageUnitButton)
        self.contentView.addSubview(dosageUnitTableView)
        
        dosageCountLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(sidePaddingSizeValue)
        }
        dosageInputContainer.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(2*sidePaddingSizeValue)
            $0.top.equalTo(dosageCountLabel.snp.bottom).inset(-sidePaddingSizeValue)
            $0.bottom.equalTo(dosageUnitButton.snp.bottom)
        }
        dosageNumberInputTextField.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        dosageUnitButton.snp.makeConstraints {
            $0.top.equalTo(dosageInputContainer.snp.top)
            $0.width.equalTo(dosageInputContainer.snp.width)
            $0.trailing.equalToSuperview().inset(2*sidePaddingSizeValue)
        }
        dosageUnitTableView.snp.makeConstraints {
            $0.top.equalTo(dosageUnitButton.snp.bottom)
            $0.left.right.equalTo(dosageUnitButton)
            $0.height.equalTo(100)
            $0.bottom.equalToSuperview().inset(sidePaddingSizeValue)
        }
    }
}

extension IntakeNumberCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dosageUnits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dosageUnits[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dosageUnitButton.setTitle(dosageUnits[indexPath.row], for: .normal)
        self.delegate?.updateUnit(unit: dosageUnits[indexPath.row])
        toggleDropdown()
    }
}
