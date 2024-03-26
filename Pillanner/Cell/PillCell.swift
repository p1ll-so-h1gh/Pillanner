//
//  PillCell.swift
//  Pillanner
//
//  Created by 박민정 on 2/29/24.
//

import UIKit
import SnapKit

protocol PillCellDelegate: AnyObject {
    func updatePillTitle(_ title: String)
}

final class PillCell: UITableViewCell {
    
    weak var delegate: PillCellDelegate?
    private var onEditingProcess = false
    static let identifier = "PillCell"
    private let sidePaddingSizeValue = 20
    
    private let pillnameLabel: UILabel = {
        let label = UILabel()
        label.text = "제품명"
        label.font = FontLiteral.subheadline(style: .bold).withSize(18)
        label.frame = CGRect(x: 0, y: 0, width: 50, height: 24)
        label.alpha = 0.6
        return label
    }()
    
    private lazy var pillNameTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "제품명"
        field.textAlignment = .left
        field.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        return field
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc private func textFieldDidChanged(_ sender: Any) {
        delegate?.updatePillTitle(self.pillNameTextField.text ?? "")
    }
    
    func setupLayoutOnEditingProcess(title: String) {
        self.pillNameTextField.placeholder = title
        self.contentView.addSubview(self.pillnameLabel)
        self.contentView.addSubview(self.pillNameTextField)
        self.pillnameLabel.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview().inset(sidePaddingSizeValue)
            $0.width.equalTo(50)
        }
        self.pillNameTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.left.equalTo(self.pillnameLabel.snp.right).inset(-8)
            $0.trailing.equalToSuperview().inset(sidePaddingSizeValue)
        }
    }
    
    func titleChanged(_ title: String) {
        delegate?.updatePillTitle(title)
    }
    
    //cell 초기화 함수 - 제품명 사라지게 하기
    internal func reset() {
        self.pillNameTextField.text = ""
    }
    
    //키보드 사라지게 하는 함수
    internal func hideKeyboard() {
        self.pillNameTextField.resignFirstResponder()
    }
}
