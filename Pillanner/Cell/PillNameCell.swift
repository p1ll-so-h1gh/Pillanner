//
//  PillCell.swift
//  Pillanner
//
//  Created by 박민정 on 2/29/24.
//

import UIKit
import SnapKit

protocol PillNameCellDelegate: AnyObject {
    func updatePillTitle(_ title: String)
}

final class PillNameCell: UITableViewCell {
    
    weak var delegate: PillNameCellDelegate?
    private var onEditingProcess = false
    static let identifier = "PillCell"
    private let sidePaddingSizeValue = 20
    private var title = ""
    
    private let pillNameLabel: UILabel = {
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
        self.title = title
        self.pillNameTextField.text = title
        self.contentView.addSubview(self.pillNameLabel)
        self.contentView.addSubview(self.pillNameTextField)
        self.pillNameLabel.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview().inset(sidePaddingSizeValue)
            $0.width.equalTo(50)
        }
        self.pillNameTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.left.equalTo(self.pillNameLabel.snp.right).inset(-8)
            $0.trailing.equalToSuperview().inset(sidePaddingSizeValue)
        }
        delegate?.updatePillTitle(self.title)
        print(self.title)
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
