//
//  UserData.swift
//  Pillanner
//
//  Created by 윤규호 on 2/27/24.
//

import Foundation
import FirebaseFirestore

class UserData {
    let db = Firestore.firestore()
    
    func setDB() {
        print("UserData setting DB....")
        db.collection("Users").document("123").setData(["ID":"ykyo", "Name":"윤규호", "Password":1234])
        db.collection("Users").document("456").setData(["ID":"김영현", "Name":"김영현", "Password":1234])
    }
    
    func setUserData(id: String, name: String, password: String, phoneNumber: String) {
        db.collection("Users").document(id).setData(["ID": id, "Name": name, "Password": password, "PhoneNumber": phoneNumber], merge: true)
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
