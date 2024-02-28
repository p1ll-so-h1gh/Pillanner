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
    func createAccountDataInFirestore(ID: String, Name: String, PW: String, phoneNumber: String) {
        let queryForUserCollection = db.collection("Users").whereField("ID", isEqualTo: ID)
        
        queryForUserCollection.getDocuments{ (snapshot, error) in
            guard let snapshot = snapshot, snapshot.isEmpty else {
                print("데이터 삽입 실해, 같은 ID의 회원 정보가 존재합니다.")
                // 회원가입 실패 ALERT 위치
                return
            }
            self.db.collection("Users").document().setData([
                "ID": ID,
                "Name": Name,
                "Password": PW,
                "PhoneNumber": phoneNumber
            ])
            print("회원가입 완료")
            // 회원가입 성공 ALERT 만들기
        }
    }
    
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
