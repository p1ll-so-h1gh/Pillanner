//
//  PillAddMainViewController.swift
//  Pillanner
//
//  Created by 박민정 on 2/29/24.
//

import UIKit
import SnapKit
import SwiftUI

// 약 추가하는 부분에서는 다른 데이터 가져올 필요 없이, 반환되는 값들로 Pill 구조체 하나 뚝딱해서 만들어내야됨

final class PillAddMainViewController: UIViewController {
    
    private let sidePaddingSizeValue = 20
    private let cornerRadiusValue: CGFloat = 13
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 영양제 추가하기"
        label.font = FontLiteral.title3(style: .bold).withSize(20)
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark")?.withRenderingMode(.alwaysOriginal).withTintColor(.black), for: .normal)
        return button
    }()
    
    private let totalTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PillCell.self, forCellReuseIdentifier: PillCell.identifier)
        tableView.register(IntakeDateCell.self, forCellReuseIdentifier: IntakeDateCell.identifier)
        tableView.register(IntakeSettingCell.self, forCellReuseIdentifier: IntakeSettingCell.identifier)
        tableView.register(PillTypeCell.self, forCellReuseIdentifier: PillTypeCell.identifier)
        tableView.register(DueDateCell.self, forCellReuseIdentifier: DueDateCell.identifier)
        return tableView
    }()
    
    private lazy var addButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.pointThemeColor2
        view.layer.cornerRadius = cornerRadiusValue
        return view
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("등록하기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    private lazy var navBackButton = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.totalTableView.dataSource = self
        self.totalTableView.delegate = self
        self.totalTableView.rowHeight = UITableView.automaticDimension
        
        backButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        navBackButton.tintColor = .black
        self.navigationItem.backBarButtonItem = navBackButton
        
        setupView()
    }
    
    @objc func dismissView() {
        dismiss(animated: true)
    }
    
    //키보드 외부 터치 시 키보드 숨김처리
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       self.view.endEditing(true)
     }
    
     // 키보드 리턴 버튼 누를경우 키보드 숨김처리
     func textFieldShouldReturn(_ textField: UITextField) {
         if let pillCell = self.totalTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PillCell {
             pillCell.hideKeyboard()
         }
     }
    
    //뷰가 나타날 때 네비게이션 바 숨김
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setupView() {
        addButtonView.addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.top.bottom.leading.trailing.centerX.centerY.equalToSuperview()
        }
        
        [backButton, titleLabel, totalTableView, addButtonView].forEach {
            view.addSubview($0)
        }
        
        backButton.snp.makeConstraints {
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
            $0.bottom.equalTo(addButtonView.snp.top).inset(-sidePaddingSizeValue)
        }
        addButtonView.snp.makeConstraints {
            $0.width.equalTo(339)
            $0.height.equalTo(53)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
}

//MARK: - TableView DataSource, Delegate
extension PillAddMainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 각 인덱스에 따라 다른 커스텀 셀 반환
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PillCell", for: indexPath) as! PillCell
            cell.setupLayout()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IntakeDateCell", for: indexPath) as! IntakeDateCell
            cell.setupLayout()
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "IntakeSettingCell", for: indexPath) as! IntakeSettingCell
            cell.delegate = self
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PillTypeCell", for: indexPath) as! PillTypeCell
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeadlineCell", for: indexPath) as! DueDateCell
            cell.delegate = self
            return cell
        default:
            fatalError("Invalid index path")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let weekSelectVC = WeekdaySelectionViewController()
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.pushViewController(weekSelectVC, animated: true)
        }
    }
}

extension PillAddMainViewController: IntakeSettingDelegate {
    func addDosage() {
        let dosageAddVC = DosageAddViewController()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(dosageAddVC, animated: true)
    }
}

extension PillAddMainViewController: DueDateCellDelegate {
    func sendDate(date: String) {
        print(date)
    }
    
    func updateCellHeight() {
        self.totalTableView.reloadData()
        self.totalTableView.scrollToRow(at: IndexPath(row: 4, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
    }
}

