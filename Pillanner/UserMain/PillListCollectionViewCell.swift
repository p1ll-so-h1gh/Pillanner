//
//  PillListTableViewCell.swift
//  Pillanner
//
//  Created by 박민정 on 2/27/24.
//

import UIKit
import SnapKit

class PillListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmLabel: UILabel!
    @IBOutlet weak var pillnumLabel: UILabel!
    @IBOutlet weak var editBtn: UIButton!
//    
//    let typeLabel: UILabel = {
//        let label = UILabel()
//        return label
//    }()
//    let nameLabel: UILabel = {
//        let label = UILabel()
//        return label
//    }()
//    let alarmImg: UIImage = {
//        let Image = UIImage()
//        return Image
//    }()
//    let alarmLabel: UILabel = {
//        let label = UILabel()
//        return label
//    }()
//    let pillnumImg: UIImage = {
//        let Image = UIImage()
//        return Image
//    }()
//    let pillnumLabel: UILabel = {
//        let label = UILabel()
//        return label
//    }()
//    let editBtn: UIButton = {
//        let button = UIButton()
//        return button
//    }()
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    override func layoutSubviews()
    {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
    }
}
