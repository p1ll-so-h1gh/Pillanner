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
    
    static let shared = DataManager()
    
    let db = Firestore.firestore()
    
    private init() {}
    
    // Users Collection 내부의 document id는 현재 기기에 로그인되어있는 정보의 UID값으로 변환이 필요할 듯
    
    // create함수는 UserDefaults에 ID, PW값을 저장하게 됩니다.
    func createUserData(user: UserData) {
        let userCollection = db.collection("Users")
        let query = userCollection.whereField("ID", isEqualTo: user.ID)
        
        query.getDocuments{ (snapshot, error) in
            guard let captured = snapshot, !captured.isEmpty else {
                self.db.collection("Users").document(user.ID).setData([
                    "ID": user.ID,
                    "Password": user.password,
                    "Name": user.name,
                    "PhoneNumber": user.phoneNumber
                ])
                UserDefaults.standard.set(user.ID, forKey: "DocumentID")
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
    
    func readUserData(userID: String, completion: @escaping ([String: Any]?) -> Void){
        var output = ["": ""]
        let query = db.collection("Users").whereField("ID", isEqualTo: userID)
        
        query.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot, !snapshot.isEmpty else {
                // 데이터 없을 때
                print("사용자의 ID로 된 데이터가 없습니다.")
                return
            }
            // 데이터 있을 때
            for document in snapshot.documents {
                let dict = ["DocumentID": document.documentID ,"ID": document.data()["ID"] as! String, "Name": document.data()["Name"] as! String, "PhoneNumber": document.data()["PhoneNumber"] as! String]
                output = dict
            }
            completion(output)
        }
    }
    
    func updateUserData(userID: String, changedPassword: String, changedName: String) {
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
            
            if changedPassword != "" {
                print("oldValue = \(userDefaults.string(forKey: "Password")!)")
                print("newValue = \(changedPassword)")
                ref.updateData(["Password": changedPassword])
            }
            if changedName != "" {
                print("oldValue = \(userDefaults.string(forKey: "Name")!)")
                print("newValue = \(changedName)")
                ref.updateData(["Name": changedName])
            }
            print("데이터 수정 완료")
        }
    }
    
    func deleteUserData(userID: String) {
        let userCollection = db.collection("Users")
        let query = userCollection.whereField("ID", isEqualTo: userID)
        
        query.getDocuments{ (snapshot, error) in
            guard let snapshot = snapshot, !snapshot.isEmpty else {
                print("데이터가 없어용")
                return
            }
            let ref = userCollection.document(snapshot.documents[0].documentID)
            
            ref.delete()
            print("데이터 삭제 완료")
        }
    }
    
    // MARK: - Pill Data Functions
    func createPillData(pill: Pill) {
        // UID 값으로 대체하면 좋을 것 같음...
        if let userID = UserDefaults.standard.string(forKey: "ID") {
            readUserData(userID: userID) { userData in
                if let userData = userData {
                    let userDocumentID = userData["DocumentID"]
                    let pillCollection = self.db.collection("Users").document(userDocumentID as! String).collection("Pills")
                    let query = pillCollection.whereField("Title", isEqualTo: pill.title)
                    
                    query.getDocuments{ (snapshot, error) in
                        guard let captured = snapshot, !captured.isEmpty else {
                            pillCollection.document("\(pill.title)").setData([
                                "Title": pill.title,
                                "Type": pill.type,
                                "Day": pill.day,
                                "DueDate": pill.dueDate,
                                "Intake": pill.intake,
                                "Dosage": pill.dosage
                            ])
                            print("약 등록 완료")
                            return
                        }
                        print("이미 같은 약 이름으로 등록이 되어있어요.")
                        print("약 이름을 바꿔서 등록해주세요")
                    }
                }
            }
        }
    }
    
    // func readPillListData 구현 필요
    
    func readPillData(pillTitle: String, completion: @escaping ([String: Any]?) -> Void) {
        var output = [String: Any]()
        if let documentID = UserDefaults.standard.string(forKey: "DocumentID") {
            let pillCollection = self.db.collection("Users").document(documentID).collection("Pills")
            let query = pillCollection.whereField("Title", isEqualTo: pillTitle)
            
            query.getDocuments { (snapshot, error) in
                guard let snapshot = snapshot else {
                    print("No pill information with that title.")
                    return
                }
                for document in snapshot.documents {
                    if let title = document.data()["Title"] ,let type = document.data()["Type"], let day = document.data()["Day"], let dueDate = document.data()["DueDate"], let intake = document.data()["Intake"], let dosage = document.data()["Dosage"] {
                        let dict = ["Title": title ,"Type": type, "Day": day, "DueDate": dueDate, "Intake": intake, "Dosage": dosage]
                        output = dict
                    }
                }
                completion(output)
            }
        }
    }
    
    
    // 약 이름 받아서 -> 그거랑 같은 데이터 먼저 찾고 -> 접근해서 새로운 데이터로 바꾸기
    func updatePillData(oldTitle: String, newTitle: String, type: String, day: [Int], dueDate: String, intake: [String], dosage: Double) {
        if let userDocumentID = UserDefaults.standard.string(forKey: "DocumentID") {
            
            let pillCollection = db.collection("Users").document(userDocumentID).collection("Pills")
            let query = pillCollection.whereField("Title", isEqualTo: oldTitle)
            
            query.getDocuments{(snapshot, error) in
                guard let snapshot = snapshot, !snapshot.isEmpty else {
                    print("잘못된 접근입니다...")
                    return
                }
                print("약 정보 수정을 시작합니다.")
                
                let oldRef = pillCollection.document(oldTitle)
                let newRef = pillCollection.document(newTitle)
                
                oldRef.delete()
                newRef.setData(["Title": newTitle ,"Type": type, "Day": day, "DueDate": dueDate, "Intake": intake, "Dosage": dosage])
            }
            print("약 정보가 업데이트 되었습니다.")
        }
        
    }
    
    
    
    
    func deletePillData(title: String) {
        if let userDocumentID = UserDefaults.standard.string(forKey: "DocumentID") {
            let pillCollection = db.collection("Users").document(userDocumentID).collection("Pills")
            
            let ref = pillCollection.document(title)
            ref.delete()
            print("약 데이터가 삭제되었습니다.")
        }
    }
    
    // 약 복용 로그를 저장할 수 있는 메서드 구현 필요
    // func createPillRecordData
    // func readPillRecordData
    
    
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
