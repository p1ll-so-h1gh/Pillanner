//
//  CustomTableViewCell.swift
//  ExCalendar
//
//  Created by Joseph on 2/27/24.
//

import UIKit

class CheckPillCell: UITableViewCell {

    private var isSelectedCell: Bool = false
    private var medicine: Medicine?

    private let pillImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()

    private let dosageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    private let prescriptionImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "prescription")
        return imageView
    }()

    private let checkmarkImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .black
        imageView.isHidden = true
        return imageView
    }()

    // MARK: - Initialization

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        isSelectedCell = selected
        updateCellSelection()
        updateCheckmark()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    // MARK: - UI Setup

    private func setupUI() {
        textLabel?.textColor = .black
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.pointThemeColor2.cgColor
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true

//        contentView.layer.shadowColor = UIColor.black.cgColor
//        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
//        contentView.layer.shadowOpacity = 0.2
//        contentView.layer.shadowRadius = 4
//
//        contentView.clipsToBounds = false

        contentView.addSubview(pillImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dosageLabel)
        contentView.addSubview(prescriptionImage)
        contentView.addSubview(checkmarkImage)

        setupConstraint()
    }

    // MARK: - Constraint

    private func setupConstraint() {
        pillImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(30)
        }

        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-10)
            $0.leading.equalTo(pillImage.snp.trailing).offset(20)
        }

        dosageLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(10)
            $0.leading.equalTo(pillImage.snp.trailing).offset(20)
        }

        prescriptionImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(nameLabel.snp.trailing).offset(25)
            $0.width.equalTo(35)
            $0.height.equalTo(25)
        }

        checkmarkImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-30)
            $0.width.height.equalTo(20)
        }
    }

    // MARK: - Cell Selection

    private func updateCellSelection() {
        if isSelectedCell, let medicine = medicine {
            contentView.layer.backgroundColor = UIColor.pointThemeColor2.cgColor
            pillImage.image = UIImage(named: medicine.imageName)
        } else {
            contentView.layer.backgroundColor = UIColor.clear.cgColor
            if let originalImage = UIImage(named: medicine?.imageName ?? "pill") {
                if let adjustedImage = originalImage.withSaturation(0.1) {
                    pillImage.image = adjustedImage
                }
            }
        }
    }

    // 체크표시
    private func updateCheckmark() {
        checkmarkImage.isHidden = !isSelectedCell
    }

    func configure(with medicine: Medicine) {
        self.medicine = medicine
        pillImage.image = UIImage(named: medicine.imageName)
        nameLabel.text = medicine.name
        dosageLabel.text = medicine.dosage
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
    }

    // 셀 테두리 안쪽만 터치
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitFrame = bounds.inset(by: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
        return hitFrame.contains(point) ? self : nil
    }
}

// MARK: - Extension

extension UIImage {
    func withSaturation(_ saturation: CGFloat) -> UIImage? {
        guard let ciImage = CIImage(image: self) else { return nil }
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(saturation, forKey: kCIInputSaturationKey)

        guard let outputCIImage = filter?.outputImage else { return nil }
        let context = CIContext(options: nil)
        guard let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return nil }

        return UIImage(cgImage: outputCGImage)
    }
}
