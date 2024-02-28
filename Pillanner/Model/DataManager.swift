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
    func createAccountDataInFirestore(signUpAvailableFlag: Bool, ID: String, Name: String, PW: String, PWCheck: String, phoneNumber: String) {
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
}
