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
    func readUserData(userID: String) {
        let query = db.collection("Users").whereField("ID", isEqualTo: userID)
        
        query.getDocuments { (snapshot, error) in
            guard let snapshot = snapshot, !snapshot.isEmpty else {
                // 데이터 없을 때
                print("사용자의 ID로 된 데이터가 없습니다.")
                return
            }
            // 데이터 있을 때
            print("데이터를 읽어옵니다.")
            for document in snapshot.documents {
                print("\(document.documentID) => \(document.data())")
            }
        }
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
    func deleteUserData(userID: String) {
        let userDefaults = UserDefaults.standard
        let userCollection = db.collection("Users")
        let query = userCollection.whereField("ID", isEqualTo: userID)
        
        query.getDocuments{ (snapshot, error) in
            guard let snapshot = snapshot, !snapshot.isEmpty else {
                print("데이터가 없어용")
                return
            }
            let ref = userCollection.document(snapshot.documents[0].documentID)
            
            userDefaults.removeObject(forKey: "ID")
            userDefaults.removeObject(forKey: "Password")
            userDefaults.removeObject(forKey: "Name")
            userDefaults.removeObject(forKey: "PhoneNumber")
            ref.delete()
            
            print("데이터 삭제 완료")
        }
    }
    
    // MARK: - Modifying Pill Data
    
    
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
