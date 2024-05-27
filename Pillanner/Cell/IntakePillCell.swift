//
//  IntakePillCell.swift
//  Pillanner
//
//  Created by 박민정 on 3/4/24.
//

import UIKit
import SnapKit

class IntakePillCell: UITableViewCell {
    private let sidePaddingValue = 6
    private let topPaddingValue = 10
    private let buttonSize = 30
    private var intake: String?
    static let identifier = "IntakePillCell"
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = FontLiteral.body(style: .regular).withSize(18)
        label.alpha = 0.7
        return label
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "dots"), for: .normal)
        let edit = UIAction(title: "수정") { _ in
            let intakeAddVC = IntakeAddViewController()
            intakeAddVC.savedIntake = self.intake
            // IntakeAddViewController로 이동하는 기능 추가 필요
        }
        let delete = UIAction(title: "삭제", attributes: .destructive) { _ in
            //
        }
        let buttonMenus = UIMenu(children: [edit, delete])
        button.menu = buttonMenus
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupLayoutOnEditingProcess(intake: String) {
        self.intake = intake
        self.timeLabel.text = "\(intake)"
        self.contentView.addSubview(timeLabel)
        self.contentView.addSubview(editButton)
        
        timeLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(topPaddingValue)
            $0.left.equalToSuperview().inset(sidePaddingValue)
        }
        editButton.snp.makeConstraints {
            $0.width.height.equalTo(buttonSize)
            $0.centerY.equalTo(timeLabel.snp.centerY)
            $0.right.equalToSuperview().inset(sidePaddingValue)
        }
    }
    
    // 삭제 혹은 수정 기능을 사용할 수 있도록 만들어야 함
    @objc private func editButtonTapped() {
        // 구현 필요
    }
}
