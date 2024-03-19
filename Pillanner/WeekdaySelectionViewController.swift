//
//  WeekdaySelectionViewController.swift
//  Pillanner
//
//  Created by 김가빈 on 2/29/24.
//

import UIKit
import SnapKit

// 약 정보 수정하는 뷰에서 접근할 때, 약 정보 받아올 수 있는 방법 필요 -> 이미 선택된 날짜 셀은 선택이 된 상태로 보여질 수 있도록

protocol WeekdaySelectionDelegate: AnyObject {
    func updateIntakeDate(_ date: [String])
}

class WeekdaySelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: WeekdaySelectionDelegate?
    var tableView: UITableView!
    var selectedWeekdays = Set<Int>()
    var selectedWeekdaysInString = [String]()
    
    let weekdays = ["월요일마다", "화요일마다", "수요일마다", "목요일마다", "금요일마다", "토요일마다", "일요일마다"]
    private var pageTitleLabel: UILabel!
    
//    private let loginButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("저장하기", for: .normal)
//        button.titleLabel?.font = FontLiteral.body(style: .bold)
//        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = UIColor.pointThemeColor2
//        button.layer.cornerRadius = 8
//        button.addTarget(target, action: #selector(didSaveButtonTapped), for: .touchUpInside)
//        return button
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .primaryBackgroundColor
        self.navigationItem.title = "반복"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: FontLiteral.title3(style: .bold)]
        setupTableView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        didSaveButtonTapped()
    }

    
    func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WeekdayTableViewCell.self, forCellReuseIdentifier: "WeekdayTableViewCell")
        tableView.separatorStyle = .none // 구분선 제거
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekdays.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 // 셀 높이 설정
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeekdayTableViewCell", for: indexPath) as! WeekdayTableViewCell
        cell.configure(with: weekdays[indexPath.row], isSelected: selectedWeekdays.contains(indexPath.row))
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedWeekdays.contains(indexPath.row) {
            selectedWeekdays.remove(indexPath.row)
        } else {
            selectedWeekdays.insert(indexPath.row)
        }
        tableView.reloadRows(at: [indexPath], with: .fade)
        print(selectedWeekdays)
        print(selectedWeekdaysInString)
    }
    
    // 로직 수정
    func saveSelectedWeekdaysInString() {
        for selectedWeekday in selectedWeekdays {
            if selectedWeekday == 0 {
                selectedWeekdaysInString.append("Mon")
            } else if selectedWeekday == 1 {
                selectedWeekdaysInString.append("Tue")
            } else if selectedWeekday == 2 {
                selectedWeekdaysInString.append("Wed")
            } else if selectedWeekday == 3 {
                selectedWeekdaysInString.append("Thu")
            } else if selectedWeekday == 4 {
                selectedWeekdaysInString.append("Fri")
            } else if selectedWeekday == 5 {
                selectedWeekdaysInString.append("Sat")
            } else if selectedWeekday == 6 {
                selectedWeekdaysInString.append("Sun")
            }
        }
    }
    
    @objc private func didSaveButtonTapped() {
        saveSelectedWeekdaysInString()
        
        delegate?.updateIntakeDate(selectedWeekdaysInString)
        print(selectedWeekdaysInString)
    }
}

class WeekdayTableViewCell: UITableViewCell {
    
    let containerView = UIView()
    let weekdayLabel = UILabel()
    let paddingView = UIView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupLayout()

            contentView.addSubview(paddingView)
            paddingView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(50)
                make.bottom.equalToSuperview().offset(50)
                make.left.right.equalToSuperview()
            }

            paddingView.addSubview(containerView)
            containerView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(weekdayLabel)
        
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.left.right.equalToSuperview()
        }
        
        weekdayLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.tertiaryLabel.cgColor
        containerView.backgroundColor = .white
    }
    
    func configure(with weekday: String, isSelected: Bool) {
        weekdayLabel.text = weekday
        weekdayLabel.font = FontLiteral.subheadline(style: .regular)
      
        UIView.animate(withDuration: 0.3) {
            self.containerView.backgroundColor = isSelected ? UIColor.pointThemeColor2 : .white
        }
    }
}

