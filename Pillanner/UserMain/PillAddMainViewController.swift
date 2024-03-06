//
//  PillAddMainViewController.swift
//  Pillanner
//
//  Created by 박민정 on 2/29/24.
//

import UIKit
import SnapKit
import SwiftUI

final class PillAddMainViewController: UIViewController {
    private let sidePaddingSizeValue = 20
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 영양제 추가하기"
        label.font = FontLiteral.title3(style: .bold).withSize(20)
        return label
    }()
    private let backBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "backBtn"), for: .normal)
        return button
    }()
    private let totalTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PillCell.self, forCellReuseIdentifier: PillCell.id)
        tableView.register(IntakeDateCell.self, forCellReuseIdentifier: IntakeDateCell.id)
        tableView.register(IntakeSettingCell.self, forCellReuseIdentifier: IntakeSettingCell.id)
        tableView.register(PillTyeCell.self, forCellReuseIdentifier: PillTyeCell.id)
        tableView.register(DeadlineCell.self, forCellReuseIdentifier: DeadlineCell.id)
        return tableView
    }()
    private let addBtnView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainThemeColor
        view.layer.cornerRadius = 5
        return view
    }()
    private let addBtn: UIButton = {
        let button = UIButton()
        button.setTitle("등록하기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.totalTableView.dataSource = self
        self.totalTableView.rowHeight = UITableView.automaticDimension
        backBtn.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        setupView()
    }
    @objc func dismissView() {
        dismiss(animated: true)
    }
    private func setupView() {
        addBtnView.addSubview(addBtn)
        addBtn.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        [backBtn, titleLabel, totalTableView, addBtnView].forEach {
            view.addSubview($0)
        }
        backBtn.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(sidePaddingSizeValue)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.centerX.equalToSuperview()
        }
        totalTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).inset(-sidePaddingSizeValue)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(addBtnView.snp.top).inset(-sidePaddingSizeValue)
        }
        addBtnView.snp.makeConstraints {
            $0.width.equalTo(301)
            $0.height.equalTo(53)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
}

extension PillAddMainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 각 인덱스에 따라 다른 커스텀 셀 반환
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PillCell", for: indexPath) as! PillCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IntakeDateCell", for: indexPath) as! IntakeDateCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IntakeSettingCell", for: indexPath) as! IntakeSettingCell
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PillTyeCell", for: indexPath) as! PillTyeCell
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeadlineCell", for: indexPath) as! DeadlineCell
            return cell
        default:
            fatalError("Invalid index path")
        }
    }
}
