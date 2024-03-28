//
//  CustomTableViewCell.swift
//  ExCalendar
//
//  Created by Joseph on 2/27/24.
//

import UIKit

class CheckPillCell: UITableViewCell {
    
    var isSelectedCell: Bool = false
    private var pill: Pill?
    
    // MARK: - Properties
    
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
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let countDosageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "복용량"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private let dosageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private let takingTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "복용시간"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        return label
    }()
    
    private let typeLabelView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7
        view.backgroundColor = UIColor.pointThemeColor3
        return view
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = FontLiteral.body(style: .bold).withSize(14)
        return label
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
        
        contentView.addSubview(pillImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(countDosageLabel)
        contentView.addSubview(dosageLabel)
        contentView.addSubview(takingTimeLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(typeLabelView)
        typeLabelView.addSubview(typeLabel)
        contentView.addSubview(checkmarkImage)
        
        setupConstraint()
    }
    
    func configure(with pill: Pill) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        self.pill = pill
        nameLabel.text = pill.title
        dosageLabel.text = String(pill.dosage)
        timeLabel.text = pill.intake[0]
        typeLabel.text = pill.type
    }
    
    // MARK: - Constraint
    
    private func setupConstraint() {
        pillImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.width.height.equalTo(30)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-13)
            $0.leading.equalTo(pillImage.snp.trailing).offset(20)
        }
        
        countDosageLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(13)
            $0.leading.equalTo(pillImage.snp.trailing).offset(20)
        }
        
        dosageLabel.snp.makeConstraints {
            $0.centerY.equalTo(countDosageLabel)
            $0.leading.equalTo(countDosageLabel.snp.trailing).offset(10)
        }
        
        takingTimeLabel.snp.makeConstraints {
            $0.centerY.equalTo(countDosageLabel)
            $0.leading.equalTo(dosageLabel.snp.trailing).offset(15)
        }
        
        timeLabel.snp.makeConstraints {
            $0.centerY.equalTo(countDosageLabel)
            $0.leading.equalTo(takingTimeLabel.snp.trailing).offset(10)
        }
        
        typeLabelView.snp.makeConstraints {
            $0.centerY.equalTo(nameLabel)
            $0.leading.equalTo(nameLabel.snp.trailing).offset(15)
            $0.width.equalTo(50)
            $0.height.equalTo(nameLabel)
        }
        
        typeLabel.snp.makeConstraints {
            $0.center.equalTo(typeLabelView)
        }
        
        checkmarkImage.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-30)
            $0.width.height.equalTo(20)
        }
    }
    
    // MARK: - 셀 선택
    
    private func updateCellSelection() {
        if isSelectedCell {
            contentView.layer.backgroundColor = UIColor.white.cgColor
            if let originalImage = UIImage(named: "pill"),
               let adjustedImage = originalImage.withSaturation(0.1) {
                pillImage.image = adjustedImage
            }
            
            // 팝 효과 및 크기 조절
            let shrinkTransform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
                self.contentView.transform = shrinkTransform
                self.typeLabelView.backgroundColor = .systemGray5
                
            }) { animationCompleted in
                // 줄어든 상태 유지
                self.contentView.transform = shrinkTransform
            }
        } else {
            contentView.layer.backgroundColor = UIColor.pointThemeColor2.cgColor
            typeLabelView.backgroundColor = UIColor.pointThemeColor3
            pillImage.image = UIImage(named: "pill")
            contentView.transform = .identity
        }
    }
    
    // 체크표시
    private func updateCheckmark() {
        checkmarkImage.isHidden = !isSelectedCell
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20))
        contentView.layer.cornerRadius = 15
    }
    
    // 셀 테두리 안쪽만 터치
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitFrame = bounds.inset(by: UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20))
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
