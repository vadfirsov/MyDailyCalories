//
//  PreLoginVC.swift
//  MyDailyCalories
//
//  Created by VADIM FIRSOV on 28/11/2019.
//  Copyright © 2019 VADIM FIRSOV. All rights reserved.
//

import UIKit

class PreLoginVC : UIViewController {
    private let goToLogin = "goToLogin"
    private let goToMainScreen = "goToMainScreen"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        FirebaseManager.shared.delegate = self
        FirebaseManager.shared.checkIfUserLoggedIn() //leak
    }
}

extension PreLoginVC : FirebaseDelegate {
    func user(isLogin: Bool) {
        if isLogin {
            performSegue(withIdentifier: goToMainScreen, sender: self)
        }
        else {
            performSegue(withIdentifier: goToLogin, sender: self)
        }
    }
}
