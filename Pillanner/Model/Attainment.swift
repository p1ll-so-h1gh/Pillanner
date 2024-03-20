//
//  Attainment.swift
//  Pillanner
//
//  Created by 박민정 on 3/19/24.
//

import UIKit

// 타이머 지정해서 타이머 리셋 메소드 추가 필요
// 이후 MainUser viewWillAppear될 때, app 진입 시에 이 메소드 호출해서 리셋이 필요한지 안한지 확인 필요
class Attainment: CalendarViewDelegate {
    var totalEvent: Int = 0
    var takenEvent: Int = 0
    
    var attainmentDidChange: ((Int) -> Void)?
    
    init(vc: CalendarViewController) {
        vc.delegate = self
    }
    
    //전달받은 토탈 이벤트 저장해줌
    func sendTotalEvent(event: Int) {
        self.totalEvent = event
    }
    
    //복용된 약 변할때마다 firebase에서 데이터 다시 가져오기
    func takenPillChanged() {
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
        
        let todaysDate = dateFormatter.date(from: Date().toString())
        
        var takenPills = [TakenPill]()
        if let UID = UserDefaults.standard.string(forKey: "UID") {
            DataManager.shared.readPillRecordData(UID: UID) { list in
                guard let list = list else {
                    print("복용한 약의 데이터가 없습니다.")
                    return
                }
                
                //오늘 날짜 약들만 가져오기
                for pill in list {
                    if todaysDate == dateFormatter.date(from: pill["TakenDate"] as! String) {
                        let data = TakenPill(title: pill["Title"] as! String, takenDate: pill["TakenDate"] as! String, intake: pill["Intake"] as! String, dosage: pill["Dosage"] as! String)
                        takenPills.append(data)
                    }
                }
                // 복용한 이벤트 수 저장
                self.takenEvent = takenPills.count
                
                // 달성률 계산 후 클로저 호출
                let calculatedData = self.calculateAttainment()
                self.attainmentDidChange?(calculatedData)
                //attinmentDidChange될때 createCircle이 되도록
                //계산이 다 된 후에 그리도록
            }
        }
    }
    
    //하루 달성률 계산하기
    private func calculateAttainment() -> Int {
        if totalEvent != 0 {
            let calculatedData = Double(takenEvent) / Double(totalEvent) * 100
            return Int(calculatedData)
        } else {
            return 0
        }
    }
}
