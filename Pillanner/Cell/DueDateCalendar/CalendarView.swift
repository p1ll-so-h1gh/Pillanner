//
//  CalendarView.swift
//  Pillanner
//
//  Created by 박민정 on 3/4/24.
//

import UIKit
import SnapKit

protocol CalendarCollectionDelegate: AnyObject {
    func sendDateData(date: String)
}

final class CalendarCollectionView: UICollectionView {
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let height = self.contentSize.height + self.contentInset.top + self.contentInset.bottom
        return CGSize(width: self.contentSize.width, height: height)
    }
}

class CalendarView: UIView, MonthYearBarViewDelegate {
    private let sidePaddingSizeValue = 10
    private let betweenPadidngSizeValue = 10
    private var numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    private var currentMonthIndex: Int = 0
    private var currentYear: Int = 0
    private var presentMonthIndex = 0
    private var presentYear = 0
    private var todaysDate = 0
    private var firstWeekDayOfMonth = 0
    
    weak var delegate: CalendarCollectionDelegate?
    
    private let monthView: MonthYearBarView = {
        let view = MonthYearBarView()
        return view
    }()
    
    private let weekdaysView: WeekdaysView = {
        let view = WeekdaysView()
        return view
    }()
    
    private let dayCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.allowsMultipleSelection = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(hexCode: "F5F5F5")
        self.layer.cornerRadius = 15
        initializeView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeView() {
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
        firstWeekDayOfMonth = getFirstWeekDay()
        
        //29일인 2월
        if currentMonthIndex == 2 && currentYear % 4 == 0 {
            numOfDaysInMonth[currentMonthIndex - 1] = 29
        }
        
        presentMonthIndex = currentMonthIndex
        presentYear = currentYear
        
        setupView()
        
        dayCollectionView.delegate = self
        dayCollectionView.dataSource = self
        dayCollectionView.register(dateCVCell.self, forCellWithReuseIdentifier: "Cell1")
    }
    
    private func setupView() {
        self.addSubview(monthView)
        monthView.delegate = self
        monthView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(betweenPadidngSizeValue)
            $0.left.right.equalToSuperview().inset(sidePaddingSizeValue)
            $0.height.equalTo(37.5)
        }
        self.addSubview(weekdaysView)
        weekdaysView.snp.makeConstraints {
            $0.top.equalTo(monthView.snp.bottom).inset(-betweenPadidngSizeValue)
            $0.left.right.equalToSuperview().inset(sidePaddingSizeValue)
            $0.height.equalTo(37.5)
        }
        self.addSubview(dayCollectionView)
        dayCollectionView.snp.makeConstraints {
            $0.top.equalTo(weekdaysView.snp.bottom).inset(-betweenPadidngSizeValue)
            $0.left.right.equalToSuperview().inset(sidePaddingSizeValue)
            $0.bottom.equalToSuperview().inset(betweenPadidngSizeValue)
            $0.height.equalTo(212)
        }
    }
}

//MARK: - CalendarView extension func
extension CalendarView {
    private func getFirstWeekDay() -> Int {
        let day = ("\(currentYear) - \(currentMonthIndex) - 01".date?.firstDayOfTheMonth.weekday)!
        return day
    }
    
    func didChangeMonth(monthIndex: Int, year: Int) {
        currentMonthIndex = monthIndex + 1
        currentYear = year
        
        if monthIndex == 1 {
            if currentYear % 4 == 0 {
                numOfDaysInMonth[monthIndex] = 29
            } else {
                numOfDaysInMonth[monthIndex] = 28
            }
        }
        
        firstWeekDayOfMonth = getFirstWeekDay()
        dayCollectionView.reloadData()
        //현재 기준보다 이 전 년으로는 이동 불가능
        monthView.btnLeft.isEnabled = !(currentMonthIndex == presentMonthIndex && currentYear == presentYear)
    }
}

//MARK: - CollectionViewDelegate, CollectionViewDataSource
extension CalendarView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfDaysInMonth[currentMonthIndex - 1] + firstWeekDayOfMonth - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell1", for: indexPath) as! dateCVCell
        cell.backgroundColor = UIColor.white
        if indexPath.item <= firstWeekDayOfMonth - 2 {
            cell.isHidden = true
        } else {
            let calcDate = indexPath.row - firstWeekDayOfMonth + 2
            cell.isHidden = false
            cell.numLabel.text = "\(calcDate)"
            if calcDate < todaysDate && currentYear == presentYear && currentMonthIndex == presentMonthIndex {
                cell.isUserInteractionEnabled = false
                cell.numLabel.textColor = UIColor.lightGray
            } else {
                cell.isUserInteractionEnabled = true
                cell.numLabel.textColor = .black
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let day = indexPath.row - firstWeekDayOfMonth + 2
        
        cell?.backgroundColor = UIColor.mainThemeColor
        
        let pickedDate = "\(currentYear)-\(currentMonthIndex)-\(day)"
        self.delegate?.sendDateData(date: pickedDate)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.white
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 7 - 4
        let height: CGFloat = 32
        return CGSize(width: width, height: height)
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionView.invalidateIntrinsicContentSize()
        collectionView.layoutIfNeeded()
    }
}

//MARK: - dateCVCell Class(CollectionView Custom Cell)
class dateCVCell: UICollectionViewCell {
    let numLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = FontLiteral.body(style: .bold).withSize(16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 5
        layer.masksToBounds = true
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(numLabel)
        numLabel.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }
}
//MARK: - Extension(Date, String)
extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
}

//get date from string
extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}
