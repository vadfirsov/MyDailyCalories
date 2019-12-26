//
//  LoginManager.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 27/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

protocol LoginDelegate { 
    func authentication(error : String)
}

class Authentication {
    
    var email : String
    var pw :    String
    var pw2 :   String?
    
    var delegate : LoginDelegate?
    
    init(email: String, pw : String, pw2 : String?) {
        self.email = email
        self.pw =    pw
        self.pw2 =   pw2
    }
    
    private func locStr(_ string : String) -> String {
        return NSLocalizedString("auth_" + string, comment: "")
    }
    
    func performSignUp() {
        if !isValid(email : email) {
            let errorString = locStr("valid_email")
            delegate?.authentication(error: errorString)
            return
        }
        else if pw != pw2! {
            let errorString = locStr("pw_dont_match")
            delegate?.authentication(error: errorString)
            return
        }

        Firebase.shared.signUpNewUser(email: email, pw: pw)
    }
    
    func performSignIn() {
        if isValid(email: email) {
            Firebase.shared.signIn(email: email, pw: pw)
        }
        else {
            let errorString = locStr("valid_email")
            delegate?.authentication(error: errorString)
        }
    }
    
    private func isValid(email : String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
