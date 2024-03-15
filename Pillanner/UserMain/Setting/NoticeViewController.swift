//
//  NoticeViewController.swift
//  Pillanner
//
//  Created by 김가빈 on 3/12/24.
//

import UIKit

class NoticeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    let notices = ["공지사항 1", "공지사항 2", "공지사항 3"] // 예시 데이터
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "공지사항"
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        setupTableView()
    }
    
    func setupTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = notices[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = NoticeDetailViewController()
        detailVC.noticeTitle = notices[indexPath.row] // 상세 뷰에 데이터 전달
        let navigationController = UINavigationController(rootViewController: detailVC) // 네비게이션 컨트롤러 생성
        navigationController.modalPresentationStyle = .fullScreen // 모달 프레젠테이션 스타일 설정
        self.present(navigationController, animated: true, completion: nil) // 모달로 상세 뷰 표시
    }
}

class NoticeDetailViewController: UIViewController {
    var noticeTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        self.navigationItem.title = noticeTitle ?? "공지사항 상세"
        
        // 닫기 버튼 추가
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(closeModal))
        
        // 공지사항 내용 레이블 추가
        let noticeContentLabel = UILabel()
        noticeContentLabel.text = "이것은 공지사항 test 입니다"
        noticeContentLabel.numberOfLines = 0 // 여러 줄 표시 가능하도록 설정
        noticeContentLabel.textAlignment = .center
        view.addSubview(noticeContentLabel)
        
        noticeContentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noticeContentLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            noticeContentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noticeContentLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func closeModal() {
        self.dismiss(animated: true, completion: nil)
    }
}
