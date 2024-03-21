//
//  Attainment.swift
//  Pillanner
//
//  Created by 박민정 on 3/19/24.
//

import UIKit

// 타이머 지정해서 타이머 리셋 메소드 추가 필요
// 이후 MainUser viewWillAppear될 때, app 진입 시에 이 메소드 호출해서 리셋이 필요한지 안한지 확인 필요

//또한 중간에 약을 추가하는 행위를 할 경우, 삭제하는 행위를 할 경우 달성률 reset하는 호출 필요

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
        
        let todaysDate = dateFormatter.string(from: Date())
        var takenPills = [TakenPill]()
        
        if let UID = UserDefaults.standard.string(forKey: "UID") {
            DataManager.shared.readPillRecordData(UID: UID) { list in
                guard let list = list, !list.isEmpty else {
                    print("복용한 약의 데이터가 없습니다.")
                    return
                }
                

                //오늘 날짜 약들만 가져오기
                for pill in list {
                    if todaysDate == pill["TakenDate"] as! String {
                        let data = TakenPill(title: pill["Title"] as! String, takenDate: pill["TakenDate"] as! String, intake: pill["Intake"] as! String, dosage: pill["Dosage"] as! String)
                        takenPills.append(data)
                    }
                }
                
                // 복용한 이벤트 수 저장
                self.takenEvent = takenPills.count
                // 달성률 계산 후 클로저 호출
                let calculatedData = self.calculateAttainment()
                self.attainmentDidChange?(calculatedData)
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
    
    //addsnapshotlistener을 통해 값 수정, 변화할 때 옵저빙으로 사용
    
    // 약이 새롭게 추가된 경우
    // 새로 추가된 약 당일 요일을 가지면 + Intake 횟수 아니면 토탈 이벤트에는 영향 X
    // 당일 요일 가질 경우 -> totalEvent 업데이트 -> 달성률 다시 계산 -> 클로저 함수에 넣어서 메인에 알려줌
    
    // collection에서 약이 삭제 될 경우
    // 삭제 액션이 일어날 때 캘린더에서 다시 토탈 이벤트 받아와야 함
    // 그리고 복용 기록 업데이트 해서 계산해야함

}
