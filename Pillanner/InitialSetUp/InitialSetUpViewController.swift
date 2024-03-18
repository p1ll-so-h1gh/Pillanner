
//  InitialSetUpViewController.swift
//  Pillanner
//
//  Created by 영현 on 2/22/24.

import UIKit
import SnapKit

class InitialSetUpViewController: UIViewController {
    
    private let sidePaddingSizeValue = 20
    private let cornerRadiusValue: CGFloat = 13
    private var count = 1
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = FontLiteral.largeTitle(style: .bold).withSize(25)
        label.textColor = UIColor.pointThemeColor2
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = FontLiteral.largeTitle(style: .bold).withSize(25)
        label.text = "번째 약의 정보를 입력해주세요"
        return label
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
    
    private lazy var addBtnView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.pointThemeColor2
        view.layer.cornerRadius = cornerRadiusValue
        return view
    }()
    
    private let addBtn: UIButton = {
        let button = UIButton()
        button.setTitle("등록하기", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    private lazy var navBackBtn = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        numberLabel.text = "\(count)"
        
        self.totalTableView.dataSource = self
        self.totalTableView.delegate = self
        self.totalTableView.rowHeight = UITableView.automaticDimension
        
        addBtn.addTarget(self, action: #selector(addPill), for: .touchUpInside)
        
        navBackBtn.tintColor = .black
        self.navigationItem.backBarButtonItem = navBackBtn
        
        setupView()
    }
    
    //뷰가 나타날 때 네비게이션 바 숨김
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
    
    @objc func addPill() {
        let title = "추가적으로 등록할 약이 있을까요?"
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        //addAdditionalPill 시 서버에 약 저장, 화면 초기화, count 증가
        let addAdditionalPill = UIAlertAction(title: "네", style: .default) { _ in
            self.count += 1
            self.resetInputValue()
            self.numberLabel.text = "\(self.count)"
        }
        //finish 시 약 정보 입력 페이지 나가고 InitialSetUpEndVC로 이동
        let finish = UIAlertAction(title: "아니요", style: .default) { _ in
            let initialSetUpEndVC = InitialSetupEndViewController()
            self.navigationController?.pushViewController(initialSetUpEndVC, animated: true)
        }
        alert.addAction(addAdditionalPill)
        alert.addAction(finish)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func resetInputValue() {
        if let pillCell = self.totalTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PillCell {
            pillCell.reset()
        }
        if let IntakeDateCell = self.totalTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? IntakeDateCell {
            IntakeDateCell.reset()
        }
        if let IntakeSettingCell = self.totalTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? IntakeSettingCell {
            IntakeSettingCell.reset()
        }
        if let PillTypeCell = self.totalTableView.cellForRow(at: IndexPath(row: 3, section: 0)) as? PillTypeCell {
            PillTypeCell.reset()
        }
        if let DeadlineCell = self.totalTableView.cellForRow(at: IndexPath(row: 4, section: 0)) as? DueDateCell {
            DeadlineCell.reset()
        }
    }
    
    private func setupView() {
        addBtnView.addSubview(addBtn)
        addBtn.snp.makeConstraints {
            $0.top.bottom.leading.trailing.centerX.centerY.equalToSuperview()
        }
        [numberLabel, titleLabel, totalTableView, addBtnView].forEach {
            view.addSubview($0)
        }
        numberLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(sidePaddingSizeValue*2)
            $0.leading.equalTo(sidePaddingSizeValue)
        }
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(numberLabel.snp.centerY)
            $0.leading.equalTo(numberLabel.snp.trailing).inset(-5)
        }
        totalTableView.snp.makeConstraints {
            $0.top.equalTo(numberLabel.snp.bottom).inset(-10)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(addBtnView.snp.top).inset(-sidePaddingSizeValue)
        }
        addBtnView.snp.makeConstraints {
            $0.width.equalTo(339)
            $0.height.equalTo(53)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
}

//MARK: - TableView DataSource, Delegate
extension InitialSetUpViewController: UITableViewDataSource, UITableViewDelegate {
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
            cell.setupLayout()
            cell.delegate = self
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PillTypeCell", for: indexPath) as! PillTypeCell
            cell.setupLayout()
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DeadlineCell", for: indexPath) as! DueDateCell
            cell.setupLayout()
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

extension InitialSetUpViewController: IntakeSettingDelegate {
    func addDosage() {
        let dosageAddVC = DosageAddViewController()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(dosageAddVC, animated: true)
    }
}

extension InitialSetUpViewController: DueDateCellDelegate {
    func updateDueDate(date: String) {
        //<#code#>
    }
    
    func sendDate(date: String) {
        print(date)
    }
    
    func updateCellHeight() {
        self.totalTableView.reloadData()
        self.totalTableView.scrollToRow(at: IndexPath(row: 4, section: 0), at: UITableView.ScrollPosition.bottom, animated: true)
    }
}
