//
//  DataManager.swift
//  Pillanner
//
//  Created by 영현 on 2/28/24.
//

import Foundation
import Firebase
import FirebaseFirestore

final class DataManager {
    
    // MARK: - Singleton Setting
    static let shared = DataManager()
    let db = Firestore.firestore()
    private init() {}
    
    
    // MARK: - SignUp Functions
    // 회원가입 시 사용하는 메서드
    func createUserData(user: UserData) {
        let userCollection = db.collection("Users")
        let query = userCollection.whereField("ID", isEqualTo: user.ID)
        
        query.getDocuments{ (snapshot, error) in
            guard let captured = snapshot, !captured.isEmpty else {
                self.db.collection("Users").document().setData([
                    "ID": user.ID,
                    "Password": user.password,
                    "Name": user.name,
                    "PhoneNumber": user.phoneNumber
                ])
                
                // 회원가입 시 UserDefaults에 데이터가 저장되어야 하나?
                UserDefaults.standard.set(user.ID, forKey: "ID")
                UserDefaults.standard.set(user.password, forKey: "Password")
                UserDefaults.standard.set(user.name, forKey: "Name")
                UserDefaults.standard.set(user.phoneNumber, forKey: "PhoneNumber")
                
                print("회원가입 완료")
                return
            }
            print("이미 같은 ID로 회원가입이 되어있음")
        }
    }
    
    // 회원정보 읽어올 때 사용하는 메서드입니다. (마이페이지 등에서 사용하면 됨)
    // Dictionary 타입의 데이터를 반환합니다. (Key: ID, Name, PhoneNumber, documentID)
    // 이 함수의 반환값(예를 들어, result)에서 키값을 활용해 사용하고자 하는 데이터에 접근할 수 있습니다. (result["ID"]와 같은 방식으로...)
    func readUserData(userID: String) -> [String: String] {
        var output = ["": ""]
        let query = db.collection("Users").whereField("ID", isEqualTo: userID)
        
        query.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot, !snapshot.isEmpty else {
                // 데이터 없을 때
                print("사용자의 ID로 된 데이터가 없습니다.")
                return
            }
            // 데이터 있을 때
            // 데이터 받아서 사용할 수 있도록 User 등의 구조체로 반환하는 기능 추가 필요
            print("데이터를 읽어옵니다.")
            for document in snapshot.documents {
                print("\(document.documentID) => \(document.data())")
                if let id = document.data()["ID"] ,let name = document.data()["Name"], let phoneNumber = document.data()["PhoneNumber"] {
                    let dict = ["documentID": document.documentID /*as! String*/ ,"ID": id as! String, "Name": name as! String, "PhoneNumber": phoneNumber as! String]
                    output = dict
                }
            }
        }
        return output
    }
    
    // 회원정보 수정 시 사용하는 메서드입니다.
    func updateUserData(userID: String, newPassword: String, newName: String) {
        let userDefaults = UserDefaults.standard
        let userCollection = db.collection("Users")
        let query = userCollection.whereField("ID", isEqualTo: userID)
        
        query.getDocuments{ (snapshot, error) in
            guard let snapshot = snapshot, !snapshot.isEmpty else {
                print("잘못된 입력입니다. ID를 다시 한 번 확인해주시기 바랍니다.")
                return
            }
            print("데이터 수정 시작")
            let ref = userCollection.document(snapshot.documents[0].documentID)
            
            // 정규식 적용하면 됨
            if newPassword != "" && self.isValidPassword(password: newPassword) {
                print("oldValue = \(userDefaults.string(forKey: "Password")!)")
                print("newValue = \(newPassword)")
                ref.updateData(["Password": newPassword])
            }
            if newName != "" {
                print("oldValue = \(userDefaults.string(forKey: "Name")!)")
                print("newValue = \(newName)")
                ref.updateData(["Name": newName])
            }
            
            print("데이터 수정 완료")
        }
    }
    
    // 회원 탈퇴 시 사용하면 됩니다
    // authentification 에서 회원정보도 삭제시켜야 함
    func deleteUserData(userID: String) {
        let userDefaults = UserDefaults.standard
        let userCollection = db.collection("Users")
        let query = userCollection.whereField("ID", isEqualTo: userID)
        
        query.getDocuments{ (snapshot, error) in
            guard let snapshot = snapshot, !snapshot.isEmpty else {
                print("데이터가 없기 때문에 삭제할 수가 없습니다.")
                return
            }
            let ref = userCollection.document(snapshot.documents[0].documentID)
            
            userDefaults.removeObject(forKey: "ID")
            userDefaults.removeObject(forKey: "Password")
            userDefaults.removeObject(forKey: "Name")
            userDefaults.removeObject(forKey: "PhoneNumber")
            ref.delete()
            
            // firebase authentification 에서도 삭제하는 기능 추가 필요
            
            print("데이터 삭제 완료")
        }
    }
    
    // MARK: - Pill Data Functions
    func createPillData(pill: Pill) {
        var userDocumentID = "" // UID 값으로 대체하면 좋을 것 같음...
        if let userID = UserDefaults.standard.string(forKey: "ID") {
            if let documentID = readUserData(userID: userID)["documentID"] {
                userDocumentID = documentID
            }
            
            let pillCollection = db.collection("Users").document(userDocumentID).collection("Pills")
            let query = pillCollection.whereField("Title", isEqualTo: pill.title)
            
//            let intakeRef = db.collection("Pills").document("Intake")
            
            query.getDocuments{ (snapshot, error) in
                guard let captured = snapshot, !captured.isEmpty else {
                    self.db.collection("Pills").document().setData([
                        "Title": pill.title,
                        "Type": pill.type,
                        "Day": pill.day,
                        "DueDate": pill.dueDate,
                        "Intake": pill.intake
                    ])
                    print("약 등록 완료")
                    return
                }
                print("이미 같은 약 이름으로 등록이 되어있어요.")
            }
        }
    }
    
    // var dict = readPillData(pillTitle: "게보린")
    // dict["Title"] => 게보린 ....
    func readPillData(pillTitle: String) -> [String: Any] {
        var userDocumentID = ""
        var output: [String: Any] = [:]
        if let userID = UserDefaults.standard.string(forKey: "ID") {
            if let documentID = readUserData(userID: userID)["documentID"] {
                userDocumentID = documentID
            }
            
            let pillCollection = db.collection("Users").document(userDocumentID).collection("Pills")
            let query = pillCollection.whereField("Title", isEqualTo: pillTitle)
            
//            let intakeRef = db.collection("Pills").document("Intake")
            
            query.getDocuments{ (snapshot, error) in
                guard let snapshot = snapshot, !snapshot.isEmpty else {
                    print("해당 이름으로 등록된 약 정보가 없습니다.")
                    return
                }
                print("데이터를 읽어옵니다.")
                for document in snapshot.documents {
                    print("\(document.documentID) => \(document.data())")
                    if let title = document.data()["Title"] ,let type = document.data()["Type"], let day = document.data()["Day"], let dueDate = document.data()["DueDate"], let intake = document.data()["Intake"] {
                        let dict = ["Title": title ,"Type": type, "Day": day, "DueDate": dueDate, "Intake": intake]
                        output = dict
                    }
                }
            }
        }
        return output
    }
    
    // 약 이름 받아서 -> 그거랑 같은 데이터 먼저 찾고 -> 접근해서 새로운 데이터로 바꾸기
    func updatePillData(oldTitle: String, newTitle: String, type: String, day: [Int], dueDate: Date, intake: [Intake]) {
        var userDocumentID = ""
        var oldValue: [String: Any] = [:]
        if let userID = UserDefaults.standard.string(forKey: "ID") {
            if let documentID = readUserData(userID: userID)["documentID"] {
                userDocumentID = documentID
            }
            let pillCollection = db.collection("Users").document(userDocumentID).collection("Pills")
            let query = pillCollection.whereField("Title", isEqualTo: oldTitle)
            
            query.getDocuments{(snapshot, error) in
                guard let snapshot = snapshot, !snapshot.isEmpty else {
                    print("잘못된 접근입니다...")
                    return
                }
                for document in snapshot.documents {
                    print("\(document.documentID) => \(document.data())")
                    if let title = document.data()["Title"] ,let type = document.data()["Type"], let day = document.data()["Day"], let dueDate = document.data()["DueDate"], let intake = document.data()["Intake"] {
                        let dict = ["Title": title ,"Type": type, "Day": day, "DueDate": dueDate, "Intake": intake]
                        oldValue = dict
                    }
                }
                let ref = pillCollection.document(oldTitle)
                
                // 여기서부터는 예전 값이랑 비교해서 차이가 있으면 ref.updateData 실행하면 됨
                if newTitle != oldValue["Title"] as! String {
                    print("oldValue = \(oldValue["Title"] as! String)")
                    print("newValue = \(newTitle)")
                    ref.updateData(["Title": newTitle])
                }
                
                if type != oldValue["Type"] as! String {
                    print("oldValue = \(oldValue["Type"] as! String)")
                    print("newValue = \(type)")
                    ref.updateData(["Type": type])
                }
                
                if day != oldValue["Day"] as! [Int] {
                    print("oldValue = \(String(describing: oldValue["Day"]))")
                    print("newValue = \(day)")
                    ref.updateData(["Day": day])
                }
                
                if dueDate != oldValue["DueDate"] as! Date {
                    print("oldValue = \(String(describing: oldValue["DueDate"]))")
                    print("newValue = \(dueDate)")
                    ref.updateData(["DueDate": dueDate])
                }
                
                if intake != oldValue["Intake"] as! [Intake] {
                    print("oldValue = \(String(describing: oldValue["Intake"]))")
                    print("newValue = \(intake)")
                    ref.updateData(["Intake": intake])
                }
            }
        }
        print("약 정보가 업데이트 되었습니다.")
    }
    
    func deletePillData(title: String) {
        var userDocumentID = ""
        if let userID = UserDefaults.standard.string(forKey: "ID") {
            if let documentID = readUserData(userID: userID)["documentID"] {
                userDocumentID = documentID
            }
            
            let pillCollection = db.collection("Users").document(userDocumentID).collection("Pills")
            let pillRef = pillCollection.document(title)
            
            print("\(title)을 이름으로 가지는 약 정보를 삭제합니다.")
            pillRef.delete()
        }
    }
    
    // MARK: - Check Format
    // 아이디 형식 검사 메서드
    func isValidID(id: String) -> Bool {
        let idRegEx = "^(?=.*[A-Za-z])(?=.*[0-9]).{5,16}$" //영문 + 숫자 조합의 5~16 자
        let idTest = NSPredicate(format: "SELF MATCHES %@", idRegEx)
        return idTest.evaluate(with: id)
    }
    
    // 비밀번호 형식 검사 메서드
    func isValidPassword(password: String) -> Bool {
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*[~!@#$%^&*])(?=.*[0-9]).{8,16}$" //영문 + 숫자 + 특수문자 조합의 8~16 자
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
}
