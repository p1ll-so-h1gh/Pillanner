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
    // MARK: - Functions about User Data
    func createUserData(user: UserData) {
        let userCollection = db.collection("Users") // CollectionReference
        let query = userCollection.whereField("ID", isEqualTo: user.ID) // DocumentReference
        
        query.getDocuments{ (snapshot, error) in
            guard let captured = snapshot, !captured.isEmpty else {
                self.db.collection("Users").document(user.UID).setData([
                    "ID": user.ID,
                    "Password": user.password,
                    "Nickname": user.nickname,
                    "SignUpPath": user.signUpPath
                ])
                UserDefaults.standard.set(user.UID, forKey: "UID")
                UserDefaults.standard.set(user.ID, forKey: "ID")
                UserDefaults.standard.set(user.password, forKey: "Password")
                UserDefaults.standard.set(user.nickname, forKey: "Nickname")
                UserDefaults.standard.set(user.signUpPath, forKey: "SignUpPath")
                print("회원가입 완료")
                return
            }
            print("이미 같은 ID로 회원가입이 되어있음")
        }
    }
    
    // 아이디 찾기
    func findIDUserData(userNickName: String, completion: @escaping (String?) -> Void) {
        var returnID = ""
        let query = db.collection("Users").whereField("Nickname", isEqualTo: userNickName)
        
        query.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot, !snapshot.isEmpty else {
                // 데이터 없을 때
                print("사용자 이름으로 된 ID가 없습니다.")
                completion(nil)
                return
            }
            // 데이터 있을 때
            for document in snapshot.documents {
                returnID = document.data()["ID"] as! String
            }
            completion(returnID) // 닉네임을 입력받아서 해당 닉네임의 아이디를 리턴 (해당 메서드는 무조건 번호인증 완료된 이후에 사용됨.)
        }
    }
    
    func readUserData(userID: String, completion: @escaping ([String: String]?) -> Void){
        
        var output = ["": ""]
        let query = db.collection("Users").whereField("ID", isEqualTo: userID)
        
        query.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot, !snapshot.isEmpty else {
                // 데이터 없을 때
                print("사용자의 ID로 된 데이터가 없습니다.")
                completion(nil)
                return
            }
            // 데이터 있을 때
            for document in snapshot.documents {
                let dict = ["UID": document.documentID,
                            "ID": document.data()["ID"] as! String,
                            "Password": document.data()["Password"] as! String,
                            "Nickname": document.data()["Nickname"] as! String,
                            "SignUpPath": document.data()["SignUpPath"] as! String]
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
                userDefaults.setValue(changedPassword, forKey: "Password")
            }
            if changedName != "" {
                print("oldValue = \(userDefaults.string(forKey: "Nickname")!)")
                print("newValue = \(changedName)")
                ref.updateData(["Nickname": changedName])
                userDefaults.setValue(changedName, forKey: "Nickname")
            }
            print("데이터 수정 완료")
        }
    }
    
    // 회원탈퇴 메서드
    func deleteUserData(UID: String) {
        // Firestore DB 삭제 (Document 통째로 삭제)
        let userCollection = db.collection("Users")
        userCollection.document(UID).delete()
        
        // UserDefaults 삭제
        UserDefaults.standard.removeObject(forKey: "UID")
        UserDefaults.standard.removeObject(forKey: "ID")
        UserDefaults.standard.removeObject(forKey: "Password")
        UserDefaults.standard.removeObject(forKey: "Nickname")
        UserDefaults.standard.removeObject(forKey: "SignUpPath")
        UserDefaults.standard.set(false, forKey: "isAutoLoginActivate")
        
        // Firebase Auth 탈퇴
        if let user = Auth.auth().currentUser {
            print("Firebase 탈퇴를 진행합니다.")
            user.delete { error in
                if let error = error {
                    print("Firebase Error : ", error)
                } else {
                    print("회원탈퇴 성공!")
                }
            }
        } else {
            print("로그인 정보가 존재하지 않습니다")
            
        }
    }
    
    // MARK: - Functions about Pill Data
    func createPillData(pill: Pill) {
        // UID 값으로 대체하면 좋을 것 같음...
        if let userID = UserDefaults.standard.string(forKey: "ID") {
            readUserData(userID: userID) { userData in
                if let userData = userData {
                    let userDocumentID = userData["UID"]
                    let pillCollection = self.db.collection("Users").document(userDocumentID!).collection("Pills")
                    let query = pillCollection.whereField("Title", isEqualTo: pill.title)
                    
                    query.getDocuments{ (snapshot, error) in
                        guard let captured = snapshot, !captured.isEmpty else {
                            pillCollection.document("\(pill.title)").setData([
                                "Title": pill.title,
                                "Type": pill.type,
                                "Day": pill.day,
                                "DueDate": pill.dueDate,
                                "Intake": pill.intake,
                                "Dosage": pill.dosage,
                                "DosageUnit": pill.dosageUnit,
                                "AlarmStatus": pill.alarmStatus
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
    
    func readPillData(pillTitle: String, completion: @escaping (Pill?) -> Void) {
        if let documentID = UserDefaults.standard.string(forKey: "UID") {
            let pillCollection = self.db.collection("Users").document(documentID).collection("Pills")
            let query = pillCollection.whereField("Title", isEqualTo: pillTitle)
            
            query.getDocuments { (snapshot, error) in
                guard let snapshot = snapshot else {
                    print("No pill information with that title.")
                    return
                }
                for document in snapshot.documents {
                    let dict = Pill(title: document.data()["Title"] as? String ?? "ftitle",
                                    type: document.data()["Type"] as? String ?? "ftype",
                                    day: document.data()["Day"] as? [String] ?? ["fday"],
                                    dueDate: document.data()["DueDate"] as? String ?? "fduedate",
                                    intake: document.data()["Intake"] as? [String] ?? ["fintake"],
                                    dosage: document.data()["Dosage"] as? String ?? "fdosage",
                                    dosageUnit: document.data()["DosageUnit"] as? String ?? "fdosageUnit",
                                    alarmStatus: document.data()["AlarmStatus"] as? Bool ?? true)
                    completion(dict)
                }
            }
            //            completion(output)
        }
    }
    
    
    func readPillListData(UID: String, completion: @escaping ([[String: Any]]?) -> Void) {
        var result = [[String: Any]]()
        print("#####", #function)
        print("###### UID ", UID)
        if let userDocumentID = UserDefaults.standard.string(forKey: "UID") {
            let pillCollection = self.db.collection("Users").document(userDocumentID).collection("Pills")
            
            pillCollection.getDocuments{ (snapshot, error) in
                guard let snapshot = snapshot, !snapshot.isEmpty else {
                    print("데이터가 없습니다.")
                    completion(nil)
                    return
                }
                print("######****#######")
                for document in snapshot.documents {
                    let docs = ["Title": document.data()["Title"],
                                "Type": document.data()["Type"],
                                "Day": document.data()["Day"],
                                "DueDate": document.data()["DueDate"],
                                "Intake": document.data()["Intake"],
                                "Dosage": document.data()["Dosage"],
                                "DosageUnit": document.data()["DosageUnit"],
                                "AlarmStatus": document.data()["AlarmStatus"]]
                    result.append(docs)
                }
                print("##### result in readPillListData Function", result)
                print(result[0]["Title"])
                completion(result)
            }
        }
    }
    
    // 약 이름 받아서 -> 그거랑 같은 데이터 먼저 찾고 -> 접근해서 새로운 데이터로 바꾸기
    
    func updatePillData(oldTitle: String, pill: Pill) {
        if let userDocumentID = UserDefaults.standard.string(forKey: "UID") {
            
            let pillCollection = db.collection("Users").document(userDocumentID).collection("Pills")
            let query = pillCollection.whereField("Title", isEqualTo: oldTitle)
            
            query.getDocuments{(snapshot, error) in
                guard let snapshot = snapshot, !snapshot.isEmpty else {
                    print("잘못된 접근입니다...")
                    return
                }
                print("약 정보 수정을 시작합니다.")
                
                // oldTitle == newTitle 일 때, 아닐 때 경우를 나누어서 로직을 구현해야 됨
                
                let oldRef = pillCollection.document(oldTitle)
                oldRef.delete()
                
                let newRef = pillCollection.document(pill.title)
                newRef.setData(["Title": pill.title ,"Type": pill.type, "Day": pill.day, "DueDate": pill.dueDate, "Intake": pill.intake, "Dosage": pill.dosage, "DosageUnit": pill.dosageUnit, "AlarmStatus": pill.alarmStatus])
            }
            print("약 정보가 업데이트 되었습니다.")
        }
        
    }
    
    func deletePillData(title: String) {
        if let userDocumentID = UserDefaults.standard.string(forKey: "UID") {
            let pillCollection = db.collection("Users").document(userDocumentID).collection("Pills")
            
            let ref = pillCollection.document(title)
            ref.delete()
            print("약 데이터가 삭제되었습니다.")
        }
    }
    
    // MARK: - Functions about Pill Record
    // 복용된 로그를 저장할 수 있는 메서드 구현 필요
    // 복용된 로그를 통해 달성률 계산
    // 이후 달성률 계산 위해서 -> 이름, 섭취날짜, 섭취량 저장?
    // 1.
    // 이름 String
    // 섭취 날짜 [String] 형태 -> 한 약에 대한 섭취 날짜들 관리 -> 이후에 지난 날에 대한 약 복용 유무 비교 가능
    // 섭취량 Double
    // 약 하나당 정보 관리 용이?
    // 2.
    // 위의 데이터 형태는 똑같지만, 한 약에 대한 관리가 아닌 단순히 복용된 약들을 통째로 저장하는 형태
    // 하나의 레코드가 이름 - 섭취 날짜 - 섭취량
    
    // 2번째 형태로 저장
    
    func createPillRecordData(pill: TakenPill) {
        if let userID = UserDefaults.standard.string(forKey: "ID") {
            readUserData(userID: userID) { userData in
                if let userData = userData {
                    let userDocumentID = userData["UID"]
                    let takenPillsCollection = self.db.collection("Users").document(userDocumentID!).collection("TakenPills")
                    
                    //복용 약 개별로 다 저장 - 기본키: TakenDate + Intake
                    takenPillsCollection.document("\(pill.title)_\(pill.intake)_\(pill.takenDate)").setData([
                        "Title": pill.title,
                        "TakenDate": pill.takenDate,
                        "Intake": pill.intake,
                        "Dosage": pill.dosage
                    ])
                }
            }
        }
    }
    
    
    func readPillRecordData(UID: String, completion: @escaping ([[String: Any]]?) -> Void) {
        var result = [[String: Any]]()
        print(#function)
        print(UID)
        let takenPillsCollection = self.db.collection("Users").document(UID).collection("TakenPills")
        
        takenPillsCollection.getDocuments{ (snapshot, error) in
            guard let snapshot = snapshot, !snapshot.isEmpty else {
                print("데이터가 없습니다.")
                completion(nil)
                return
            }
            for document in snapshot.documents {
                let docs = ["Title": document.data()["Title"],
                            "TakenDate": document.data()["TakenDate"],
                            "Intake": document.data()["Intake"],
                            "Dosage": document.data()["Dosage"]
                ]
                result.append(docs as [String : Any])
            }
            completion(result)
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

