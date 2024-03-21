//
//  NoticeViewController.swift
//  Pillanner
//
//  Created by 김가빈 on 3/12/24.
//

import UIKit

class NoticeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    let notices = ["건강한 약 루틴, 필래너와 함께해요"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "필래너 소식"
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
        detailVC.noticeTitle = notices[indexPath.row]
        let navigationController = UINavigationController(rootViewController: detailVC)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(closeModal))
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let noticeContainerView = UIView()
        noticeContainerView.layer.borderWidth = 1.0
        noticeContainerView.layer.borderColor = UIColor(hex: "F4F4F4").cgColor
        noticeContainerView.layer.cornerRadius = 10
        noticeContainerView.backgroundColor = UIColor(hex: "FAFAFA")
        noticeContainerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(noticeContainerView)
        
        NSLayoutConstraint.activate([
            noticeContainerView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            noticeContainerView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            noticeContainerView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            noticeContainerView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            noticeContainerView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -40)
        ])
        
        
        let noticeContentLabel = UILabel()
        noticeContentLabel.text = """

안녕하세요.
필래너 개발 팀입니다.


약 복용 시간을 잊는 불편함에서 출발해,
사용자가 약 복용 시간을 쉽게 기억할 수 있도록 돕는 필래너를 개발하게 되었습니다.


이를 통해 사용자분들이 더 건강한 약 복용 루틴을 구축할 수 있기를 바랍니다.


저희 서비스를 이용하시며 느끼신
개선 사항이나 불편한 점이 있으시다면
앱스토어 리뷰나 1:1 문의를 통해
소중한 의견을 남겨주세요.

필래너는 항상 여러분의 건강한 루틴 유지를 위해 최선을 다할 것입니다. 감사합니다.



"""
        noticeContentLabel.numberOfLines = 0
        noticeContentLabel.textAlignment = .left
        noticeContentLabel.translatesAutoresizingMaskIntoConstraints = false
        noticeContainerView.addSubview(noticeContentLabel)
        
        NSLayoutConstraint.activate([
            noticeContentLabel.topAnchor.constraint(equalTo: noticeContainerView.topAnchor, constant: 10),
            noticeContentLabel.leadingAnchor.constraint(equalTo: noticeContainerView.leadingAnchor, constant: 10),
            noticeContentLabel.trailingAnchor.constraint(equalTo: noticeContainerView.trailingAnchor, constant: -10),
            noticeContentLabel.bottomAnchor.constraint(equalTo: noticeContainerView.bottomAnchor, constant: -10)
        ])
    }
    
    @objc private func closeModal() {
        self.dismiss(animated: true, completion: nil)
    }
}
