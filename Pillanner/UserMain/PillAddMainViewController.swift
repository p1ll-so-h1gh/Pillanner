//
//  PillAddMainViewController.swift
//  Pillanner
//
//  Created by 박민정 on 2/29/24.
//

import UIKit
import SnapKit
import SwiftUI

struct PreView: PreviewProvider {
    static var previews: some View {
        PillAddMainViewController().toPreview()
    }
}

#if DEBUG
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController

        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }

    func toPreview() -> some View {
        Preview(viewController: self)
    }
}
#endif

final class PillAddMainViewController: UIViewController {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 영양제 추가하기"
        label.font = FontLiteral.title3(style: .bold).withSize(20)
        return label
    }()
    
    private let totalTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PillCell.self, forCellReuseIdentifier: PillCell.id)
        tableView.register(IntakeDateCell.self, forCellReuseIdentifier: IntakeDateCell.id)
        tableView.register(IntakeSettingCell.self, forCellReuseIdentifier: IntakeSettingCell.id)
        tableView.register(PillTyeCell.self, forCellReuseIdentifier: PillTyeCell.id)
        tableView.register(DeadlineCell.self, forCellReuseIdentifier: DeadlineCell.id)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.totalTableView)
        self.totalTableView.dataSource = self
        self.totalTableView.separatorStyle = .none
        self.totalTableView.rowHeight = UITableView.automaticDimension
        self.totalTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return tableView.rowHeight
        }
}
